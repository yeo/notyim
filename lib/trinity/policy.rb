# frozen_string_literal: true

require 'trinity/current'

module Trinity
  module Policy
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
