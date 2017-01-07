module Yeller
  module Provider
    extend self
    LOCK = Mutex.new

    def register(klass)
      LOCK.synchronize do
        providers[klass.to_s.split('::').last] = klass
      end
    end

    def providers
      @__providers ||= {}
    end

    def class_of(identify)
      providers.fetch(identify)
    end
  end
end

Dir.glob(File.expand_path("../provider/*.rb", __FILE__)).each do |file|
  require file
end
