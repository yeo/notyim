require_relative 'base'

module Yeller
  module Provider
    class Email < Base
      include Yeller::Processor::Testable
      include Yeller::Processor::Verifiable

      Yeller::Provider.register(self)
      Yeller::Provider.register(self)
    end
  end
end
