class CheckDecorator < SimpleDelegator
  def current_status
    '200 OK'
  end

  def mean_time(unit: :ms)
    "#{rand(4000)}ms"
  end

  def uptime_stat
    "#{rand(100)}%"
  end

  def simple_line_chart_data(duration = 24.hour)
    {
      labels: ["", "", "", "", "", ""],
      series: [
        Array.new(24) { rand(200.2000) },
      ]
    }.to_json.html_safe
  end

  def last_hour_chart_data
    {
      labels: Array.new(60) { rand(200.2000) },
      series: [
        Array.new(60) { rand(200.2000) },
      ]
    }.to_json.html_safe
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
end
