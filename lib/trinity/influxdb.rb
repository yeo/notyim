# frozen_string_literal: true

# Trinity
module Trinity
  # InfluxDB Client
  module InfluxDB
    class << self
      attr_writer :configuration
      attr_writer :client

      def configuration
        # TODO: Use a proper configurationw rapper
        @configuration ||= OpenStruct.new
      end

      def configure(_silent = false)
        yield(configuration)

        # if we change configuration, reload the client
        self.client = nil

        ::InfluxDB::Logging.logger = configuration.logger unless configuration.logger.nil?
      end

      def create_db!
        client.query %(CREATE DATABASE "#{configuration.influxdb_database}")
      end

      def drop_db!
        client.query %(DROP DATABASE "#{configuration.influxdb_database}")
      end

      def client
        @client ||= ::InfluxDB::Client.new configuration.influxdb_database,
                                           username: configuration.influxdb_username,
                                           password: configuration.influxdb_password,
                                           hosts: configuration.influxdb_hosts,
                                           port: configuration.influxdb_port,
                                           #:async => configuration.async,
                                           #:use_ssl => configuration.use_ssl,
                                           retry: configuration.retry
      end
    end
  end
end
