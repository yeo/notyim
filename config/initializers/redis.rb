# frozen_string_literal: true

# rubocop:disable Style/GlobalVars
$redis = ConnectionPool.new { Redis.new url: (ENV['REDIS'] || 'redis://127.0.0.1:6379/2') }
# rubocop:enable Style/GlobalVars
