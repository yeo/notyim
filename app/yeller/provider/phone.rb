require_relative 'base'

module Yeller
  module Provider
    class Phone < Base
      Yeller::Provider.register(self)
    end
  end
end
