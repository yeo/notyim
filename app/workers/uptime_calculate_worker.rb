class UptimeCalculateWorker
  include Sidekiq::Worker

  # @param sting check id
  # @param Hash result
  #         - total_time
  #         - body
  #         - total_size
  #         - response_code
  def perform(start_at = 0, limit = 10)
    check_ids = Check.skip(start_at).limit(limit).pluck(:id)
    return if check_ids.empty?

    check_ids.each do |id|
      check = Check.find(id.to_s)
      check.uptime_1hour = calculate(check, 1.hour)
      check.uptime_1day = calculate(check, 1.day)
      check.uptime_1month = calculate(check, 1.month)

      check.save!

      calculate_daily_uptime(check)
    end

    UptimeCalculateWorker.perform_async(start_at + limit)
  end

  def calculate(check, duration)
    open_incident = check.incidents.open.first
    if open_incident
      # Because this incident is still on-going, we set the second elemtn to now
      # to calculate downtime
      open_incident = [[open_incident.created_at, Time.now.utc]]
    else
      open_incident = []
    end

    incidents = open_incident + Incident.where(check: check, :created_at.gt => duration.ago).pluck(:created_at, :updated_at)
    if incidents.count == 0
      100
    else
      downtime = incidents.inject(0) { |sum, e| sum += (e.last - e.first) }
      if downtime >= duration.to_i
        0
      else
        100 - (downtime.to_f / duration.to_i * 100)
      end
    end
  end

  # @param Check
  def calculate_daily_uptime(check)
    today = Time.zone.now.strftime("%D")
    daily_uptime = check.daily_uptime
    if daily_uptime
      day, _ = daily_uptime.histories.last
      daily_uptime.histories.pop if day == today
    else
      daily_uptime = DailyUptime.create!(histories: [], check: check)
    end

    daily_uptime.histories << [ today, calculate(check, 1.day) ]
    daily_uptime.histories.shift if daily_uptime.histories.length > 366
    daily_uptime.save
  end
end
