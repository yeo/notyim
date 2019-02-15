# frozen_string_literal: true

require 'trinity/influxdb'

Trinity::InfluxDB.configure do |config|
  config.influxdb_database = 'noty'
  config.influxdb_username = ENV['INFLUXDB_USERNAME']
  config.influxdb_password = ENV['INFLUXDB_PASSWORD']
  config.influxdb_hosts    = (ENV['INFLUXDB_HOSTS'] || '127.0.0.1').split(',')
  config.influxdb_port     = 8086
  config.retry             = 2
  config.logger            = Rails.logger
end
