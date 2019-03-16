# frozen_string_literal: true

require 'trinity/influxdb'

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
    result = influxdb.query "select mean(time_Total) from http_response where check_id = '#{id}' AND time > now() - 1h"
    return "0#{unit}" unless result&.first

    m = result.first['values']&.first
    m['mean'] ? "#{m['mean'].round(2)}#{unit}" : "0#{unit}"
  end

  def uptime_stat
    uptime_1hour
  end

  def simple_line_chart_data(duration = 24, group = 5, label_step = 5)
    query = check_total_latency_by_min(id, group, duration)
    result = influxdb.query(query).try(:first)

    return { labels: [], series: [] } unless result

    line_chart_data_labels(result['values'], label_step)
  end

  def line_chart_data_labels(points)
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
    histogram = nil

    query = check_total_latency_by_min(id, 5, duration)
    influxdb.query(query) do |_name, _tag, points|
      histogram = Hash[*points
                  .select { |p| p['mean'].present? }
                  .map { |p| ((p['mean'] || 0).to_i / 50) * 50 }
                  .group_by { |v| v }
                  .flat_map { |k, v| [k, v.length] }]
                  .sort.flatten
    end

    return '{}' unless histogram

    {
      labels: histogram.each_with_index.select { |_v, k| k.even? }.map { |e| "#{e.first}ms" },
      series: histogram.each_with_index.select { |_v, k| k.odd? }.map(&:first)
    }.to_json.html_safe
  end

  # Return chart data for last year uptime
  # The structure is organize into a 2 dimmension array
  # first index is the week. second index is day of week
  def last_year_uptime
    return @last_year_uptime if @last_year_uptime

    first_sunday = first_dow_one_year_ago
    histories = daily_uptime ? daily_uptime.histories.to_h : {}

    @last_year_uptime ||= Array.new(52) do |week|
      Array.new(7) do |day_of_week|
        shift = first_sunday + week.week + day_of_week.day
        uptime = histories[shift.strftime('%D')] || 'unknow'

        summary_uptime(uptime, shift)
      end
    end
  end

  private

  def format_uptime(uptime)
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
    summary = format_uptime(uptime)
    stat = format_stat(uptime)

    OpenStruct.new(time: shift, up: uptime, summary: stat, desc: "#{shift.strftime '%D'}: #{summary}", stat: stat)
  end

  def influxdb
    @influxdb ||= Trinity::InfluxDB.client
  end

  def current_metric
    return @current_metric if @current_metric

    query = "select * from http_response where check_id = '#{id}' order by time desc limit 1"
    influxdb.query query do |_name, _tags, points|
      @current_metric = points.first
    end

    @current_metric
  end

  def check_total_latency_by_min(id, group, duration)
    %(SELECT mean\(time_Total\)
      FROM http_response
      WHERE check_id = '#{id}' AND time > now\(\) - #{duration}h
      GROUP BY time\(#{group}m\))
  end
end
