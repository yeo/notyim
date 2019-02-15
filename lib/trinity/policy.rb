# frozen_string_literal: true

require 'trinity/current'

# Trinity logic
module Trinity
  # Access Control
  module Policy
    # Base class
    module Base
      def owner?; end

      def can?
        false
      end

      def have?
        false
      end

      def can_manage?(_object, _user)
        false
      end
    end
  end
end
