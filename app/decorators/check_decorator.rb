# frozen_string_literal: true

class CheckDecorator < SimpleDelegator
  include CheckHelper

  def element_id
    id.to_s
  end

  def current_status
    @current_status ||= if (record = current_metric)
                          return record['status_code'] if record['status_code'].present? && record['status_code'] != 0

                          'Down' if record['status'] == '0' || record['error'] == true
                        else
                          'Unknow'
                        end
  end

  def mean_time(unit: :ms)
    result = MetricService.check_mean_time_in_last_hour(id)
    return "0#{unit}" unless result&.first

    m = result.first['values']&.first
    m['mean'] ? "#{m['mean'].round(2)}#{unit}" : "0#{unit}"
  end

  def uptime_stat
    uptime_1hour
  end

  def simple_line_chart_data(duration = 24, group = 5, label_step = 5)
    result = MetricService.latency_data(id, group, duration)
    return { labels: [], series: [] } unless result

    line_chart_data_labels(result['values'], label_step)
  end

  def line_chart_data_labels(points, label_step)
    labels = points.each_with_index.map { |p, i| (i % label_step).zero? ? Time.parse(p['time']).strftime('%H:%M') : '' }
    {
      labels: labels,
      series: [points.map { |p| p['mean']&.round(2) || 0 }]
    }
  end

  def last_hour_chart_data
    simple_line_chart_data(1, 1).to_json.html_safe
  end

  def last_day_chart_data
    simple_line_chart_data(24, 20, 5).to_json.html_safe
  end

  # Build histogram with 50ms step
  def last_day_distributed_chart_data(duration = 24)
    histogram = MetricService.check_latency(id, 5, duration)

    {
      labels: histogram.each_with_index.select { |_v, k| k.even? }.map { |e| "#{e.first}ms" },
      series: histogram.each_with_index.select { |_v, k| k.odd? }.map(&:first)
    }.to_json.html_safe
  end

  # Return chart data for last year uptime
  # The structure is organize into a 2 dimmension array
  # first index is the week. second index is day of week
  def last_year_uptime
    @last_year_uptime ||= build_52_weeks_uptime
  end

  private

  def build_52_weeks_uptime
    first_sunday = first_dow_one_year_ago
    histories = daily_uptime ? daily_uptime.histories.to_h : {}

    Array.new(52) do |week|
      Array.new(7) do |day_of_week|
        shift = first_sunday + week.week + day_of_week.day
        uptime = histories[shift.strftime('%D')] || 'unknow'

        summary_uptime(uptime, shift)
      end
    end
  end

  def format_uptime(uptime, shift)
    case uptime
    when 0
      '100% down'
    when 100
      '100% uptime'
    when 'unknow'
      if shift >= Time.now.end_of_day
        'Not monitored yet'
      else
        'No data'
      end
    else
      "#{uptime}% uptime"
    end
  end

  def format_stat(uptime)
    case uptime
    when 'unknow'
      'nodata'
    when 100
      'up'
    when 0
      'down'
    when 90..100
      'slow'
    else
      'down'
    end
  end

  def summary_uptime(uptime, shift)
    summary = format_uptime(uptime, shift)
    stat = format_stat(uptime)

    OpenStruct.new(time: shift, up: uptime, summary: stat, desc: "#{shift.strftime '%D'}: #{summary}", stat: stat)
  end

  def current_metric
    @current_metric ||= MetricService.current_metric(id)
  end
end
