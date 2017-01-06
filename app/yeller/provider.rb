module Yeller
  module Provider
    extend self
    LOCK = Mutex.new

    def register(klass)
      LOCK.synchronize do
        providers.push(klass) unless providers.include?(klass)
      end
    end

    def providers
      @__providers ||= []
    end
  end
end

Dir.glob(File.expand_path("../provider/*.rb", __FILE__)).each do |file|
  require file
end
