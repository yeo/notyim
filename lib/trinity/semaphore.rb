module Trinity
  module Semaphore
    def self.run_once(resource, lock_in = 10, value = 1)
      result = $redis.with { |c| c.set resource, value, {ex: lock_in, nx: true} }
      yield if block_given? if result == true
    end
  end
end
