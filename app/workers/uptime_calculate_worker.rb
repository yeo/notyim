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
    end


    UptimeCalculateWorker.perform_async(start_at + limit)
  end

  def calculate(check, duration)
    incidents = Incident.where(check: check, :created_at.gt => duration.ago).pluck(:created_at, :updated_at)
    if incidents.count == 0
      100
    else
      downtime = incidents.inject(0) { |sum, e| sum += (e.last - e.first) }
      100 - (downtime.to_f / duration.to_i * 100)
    end
  end
end
