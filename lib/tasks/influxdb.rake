# frozen_string_literal: true

require 'trinity/influxdb'

namespace :influxdb do
  db_name = Trinity::InfluxDB.configuration.influxdb_database
  RPS = [
    %(create retention policy "default" on "#{db_name}" duration 24h REPLICATION 1 DEFAULT;),
    %(create retention policy "an_hour" on "#{db_name}" duration 1h REPLICATION 1;),
    %(create retention policy "a_month" on "#{db_name}" duration 30d REPLICATION 1;),
    %(create retention policy "a_year" on "#{db_name}" duration 52w REPLICATION 1;)
  ].freeze

  desc 'Create influxdb database'
  task create_db: :environment do
    Trinity::InfluxDB.create_db!
  end

  desc 'Configure query and retention policy'
  task setup: :create_db do
    client = Trinity::InfluxDB.client
    RPS.each do |q|
      client.query q
    end
  end
end
