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
        Array.new(24) { rand(200.2000) },
        Array.new(24) { rand(200.2000) },
      ]
    }.to_json.html_safe
  end
end
