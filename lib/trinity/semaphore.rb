module Trinity
  module Semaphore
    def self.run_once(resource, lock_in = 10, value = 1)
      key = case resource
            when Array
              resource.map(&:to_s).join(':')
            else
              resource.to_s
            end
    
      result = $redis.with { |c| c.set(key, value, {ex: lock_in, nx: true}) }
      yield if block_given? if result == true
    end
  end
end
