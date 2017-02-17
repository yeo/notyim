class CheckDecorator < SimpleDelegator
  def current_status
    status = '200 OK'
    influxdb.query "select * from http_response where check_id = '#{id.to_s}' order by time desc limit 1" do |name, tags, points|
    end

    status
  end

  def mean_time(unit: :ms)
    result = influxdb.query "select mean(time_Total) from http_response where check_id = '#{id.to_s}' AND time > now() - 1h"
    if result&.first && m = result&.first['values']&.first['mean']
      "#{m.round(2)}ms"
    else
      "0ms"
    end
  end

  def uptime_stat
    uptime_1hour
  end

  def simple_line_chart_data(duration = 24, group = 5)
    if result = influxdb.query("select mean(time_Total) from http_response where check_id = '#{id.to_s}' AND time > now() - #{duration}h GROUP BY time(#{group}m)").try(:first)
      {
        labels: result['values'].each_with_index.map { |p, i| Time.parse(p['time']).strftime("%H:%M") if i % (group * 5) == 0},
        series: [result['values'].map { |p| p['mean']&.round(2) || 0 }],
      }.to_json.html_safe
    else
      { labels: [], series: [] }.to_json.html_safe
    end
  end

  def last_hour_chart_data
    simple_line_chart_data(1, 1)
  end

  def last_day_chart_data
    simple_line_chart_data(24, 4)
  end

  # Return chart for last year uptime
  def last_year_uptime
    now = Time.current
    Array.new(12) do |m|
      shift = now - m.month
      OpenStruct.new(
        time: shift,
        days: Array.new(Time.days_in_month(shift.month, shift.year)) do |d|
          OpenStruct.new(
            up: '90%',
            summary: 'up',
            desc: "#{shift.year}/#{shift.month}/#{d}: No down time",
            stat: ['up', 'down', 'slow'].sample
          )
        end
      )
    end
  end

  private
  def influxdb
    @__c ||= Trinity::InfluxDB.client
  end
end
