# frozen_string_literal: true

namespace :devdata do
  desc 'Create influxdb database'
  task init: :environment do
    Devdata.generate
  end
end
