# frozen_string_literal: true

class UptimeCalculateWorker
  include Sidekiq::Worker

  # @param sting check id
  # @param Hash result
  #         - total_time
  #         - body
  #         - total_size
  #         - response_code
  def perform(start_at = 0, limit = 10)
    return if (check_ids = Check.skip(start_at).limit(limit).pluck(:id)).empty?

    # Paginate
    UptimeCalculateWorker.perform_async(start_at + limit)

    check_ids.each { |id| perform_one(Check.find(id.to_s)) }
  end

  private

  def perform_one(check)
    check.uptime_1hour = calculate(check, 1.hour)
    check.uptime_1day = calculate(check, 1.day)
    check.uptime_1month = calculate(check, 1.month)

    begin
      check.save!
    rescue Mongoid::Errors::Validations => exception
      Bugsnag.notify(exception) do |report|
        # Adjust the severity of this error
        report.severity = 'error'

        # Add customer information to this report
        report.add_tab(:check, id: check.id.to_s)
      end
    end

    calculate_daily_uptime(check)
  end

  def calculate(check, duration)
    open_incident = check.incidents.open.first
    # Because this incident is still on-going, we set the second elemtn to now
    # to calculate downtime
    open_incident_times = open_incident ? [[open_incident.created_at, Time.now.utc]] : []

    incidents = open_incident_times + Incident.where(
      check: check, :created_at.gt => duration.ago
    ).pluck(:created_at, :closed_at)

    calculate_with_incident(incidents, duration)
  end

  # @param Check
  def calculate_daily_uptime(check)
    today = Time.zone.now.strftime('%D')

    daily_uptime = check.daily_uptime
    if daily_uptime
      day, = daily_uptime.histories.last
      daily_uptime.histories.pop if day == today
    else
      daily_uptime = DailyUptime.create!(histories: [], check: check)
    end

    add_history_to_uptime(check, daily_uptime)
  end

  def add_history_to_uptime(check, uptime)
    uptime.histories << [today, calculate(check, 1.day)]

    uptime.histories.shift if uptime.histories.length > 366
    uptime.save
  end

  def calculate_with_incident(incidents, duration)
    # If an incident has not close, it has no second element, so we default to Time.now.utc
    downtime = downtime_from_incidents(incidents)
    return 0 if downtime >= duration.to_i

    100 - (downtime.to_f / duration.to_i * 100)
  end

  def downtime_from_incidents(incidents)
    incidents.inject(0) { |sum, e| sum + ((e.last || Time.now.utc) - e.first) }
  end
end
