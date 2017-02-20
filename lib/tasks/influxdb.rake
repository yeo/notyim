namespace :influxdb do
  desc "Configure query and retention policy"
  RPS = [
    'create retention policy "default" on "noty" duration 24h REPLICATION 1 DEFAULT;',
    'create retention policy "an_hour" on "noty" duration 1h REPLICATION 1;',
    'create retention policy "a_month" on "noty" duration 30d REPLICATION 1;',
    'create retention policy "a_year" on "noty" duration 52w REPLICATION 1;'
  ]

  task setup: :environment do
    client = Trinity::InfluxDB.client
    RPS.each do |q|
      client.query q
    end
  end
end
