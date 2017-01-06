require_relative 'base'

module Yeller
  module Provider
    class Slack < Base
      Yeller::Provider.register(self)
    end
  end
end
