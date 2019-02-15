# frozen_string_literal: true

require 'gaia'

Gaia.configure do |config|
  config.add ip: '168.235.98.16', region: 'Macon, Georgia, United States'
  config.add ip: '45.76.209.165', region: 'Tokyo, Japan'
  config.add ip: '163.172.164.40', region: 'Paris, France'
end
