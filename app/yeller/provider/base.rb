module Yeller
  module Provider
    class Base
      def self.identity
        name.split('::').last
      end
    end
  end
end
