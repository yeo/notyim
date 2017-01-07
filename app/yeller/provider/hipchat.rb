require_relative 'base'

module Yeller
  module Provider
    class Hipchat < Base
      Yeller::Provider.register(self)
    end
  end
end
