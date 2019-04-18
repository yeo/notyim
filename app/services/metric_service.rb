# frozen_string_literal: true

require 'trinity/influxdb'

class MetricService
  def self.influxdb
    # TODO: Thread-safe
    @influxdb ||= Trinity::InfluxDB.client
  end

  def self.current_metric(id)
    query = "select * from http_response where check_id = '#{id}' order by time desc limit 1"
    metric = nil
    metric.tap do
      influxdb.query(query) { |_name, _tags, points| metric = points.first }
    end
  end

  def self.check_mean_time_in_last_hour(id)
    influxdb.query "select mean(time_Total) from http_response where check_id = '#{id}' AND time > now() - 1h"
  end

  def self.latency_data(id, group_by_minute, duration_in_hour)
    stmt = check_total_latency_by_minute(id, group_by_minute, duration_in_hour)

    influxdb.query(stmt).try(:first)
  end

  def self.check_latency(id, group_by_minute, duration_in_hour)
    histogram = []
    stmt = check_total_latency_by_minute(id, group_by_minute, duration_in_hour)

    influxdb.query(stmt) do |_name, _tag, points|
      histogram = points_to_histogram(points)
    end

    histogram
  end

  def self.points_to_histogram(points)
    Hash[*points.select { |p| p['mean'].present? }
                .map { |p| ((p['mean'] || 0).to_i / 50) * 50 }
                .group_by { |v| v }
                .flat_map { |k, v| [k, v.length] }]
      .sort
      .flatten
  end
  private_class_method :points_to_histogram

  def self.check_total_latency_by_minute(id, group_by_minute, duration_in_hour)
    %(SELECT mean\(time_Total\)
      FROM http_response
      WHERE check_id = '#{id}' AND time > now\(\) - #{duration_in_hour}h
      GROUP BY time\(#{group_by_minute}m\))
  end
  private_class_method :check_total_latency_by_minute
end
