require_relative 'base'

module Yeller
  module Provider
    class Hipchat < Base
      include Yeller::Processor::Testable
      include Yeller::Processor::Verifiable

      Yeller::Provider.register(self)
    end
  end
end
