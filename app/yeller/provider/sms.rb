require_relative 'base'

module Yeller
  module Provider
    class Sms < Base
      Yeller::Provider.register(self)

    end
  end
end
