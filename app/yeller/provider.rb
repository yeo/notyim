# frozen_string_literal: true

module Yeller
  module Provider
    module_function

    LOCK = Mutex.new

    def register(klass)
      LOCK.synchronize do
        providers[klass.to_s.split('::').last] = klass
      end
    end

    def providers
      @providers ||= {}
    end

    def class_of(identify)
      identify && providers.fetch(identify)
    end
  end
end

Dir.glob(File.expand_path('provider/*.rb', __dir__)).each do |file|
  require file
end
