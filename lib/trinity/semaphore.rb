# frozen_string_literal: true

# Trinity share
module Trinity
  # Semaphore to handle distributed mutex
  module Semaphore
    def self.run_once(resource, lock_in = 10, value = 1)
      key = case resource
            when Array
              resource.map(&:to_s).join(':')
            else
              resource.to_s
            end

      result = $redis.with { |c| c.set(key, value, ex: lock_in, nx: true) } # rubocop:disable Style/GlobalVars
      yield if result == true && block_given?
    end
  end
end
