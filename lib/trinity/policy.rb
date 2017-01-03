require 'trinity/current'

module Trinity
  module Policy
    module Base
      def owner?
      end

      def can?
        false
      end

      def have?
        false
      end

      def can_manage?(object, user)
        false
      end
    end
  end
end
