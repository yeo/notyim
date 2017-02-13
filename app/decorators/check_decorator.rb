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
      datasets: [{
        label: 'France',
        lineTension: 0.1,
        pointRadius: 1,
        pointBorderWidth: 1,
        data: [12, 19, 3, 5, 2, 3],
        backgroundColor: 'rgba(54, 162, 235, 0.2)',
        borderColor: 'rgba(255, 206, 86, 1)',
        borderWidth: 1
      }, {
        label: 'Georgia',
        lineTension: 0.1,
        pointRadius: 1,
        pointBorderWidth: 1,
        data: [2, 9, 3, 3, 1, 7],
        backgroundColor: [
          'rgba(255, 99, 132, 0.2)',
        ],
        borderColor: [
          'rgba(153, 102, 255, 1)',
        ],
        borderWidth: 1
      },{
        label: 'Tokyo',
        lineTension: 0.1,
        pointRadius: 1,
        pointBorderWidth: 1,
        data: [2, 9, 3, 3, 1, 7],
        backgroundColor: [
          'rgba(255, 99, 132, 0.2)',
        ],
        borderColor: [
          'rgba(153, 102, 255, 1)',
        ],
        borderWidth: 1
      }]
    }.to_json.html_safe
  end
end
