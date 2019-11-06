# frozen_string_literal: true

module Yeller
  module Processor
    module Testable
      def perform_test(_payload)
        raise 'Implement this'
      end
    end
  end
end
