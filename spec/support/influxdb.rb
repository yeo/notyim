# frozen_string_literal: true

module TestUtils
  module InfluxDB
    def use_influxdb
      Trinity::InfluxDB.create_db!
    end

    def cleanup_influxdb!
      Trinity::InfluxDB.drop_db!
    end
  end
end

RSpec.configure do |config|
  config.include TestUtils::InfluxDB
end
