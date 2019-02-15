# frozen_string_literal: true

# Trinity
module Trinity
  # Config handling
  class Config
    class << self
      def configure
        yield instance
      end

      def instance; end
    end
  end
end
