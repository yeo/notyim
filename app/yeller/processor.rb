module Yeller
  module Processor
    def self.included(base)
      base.after_create :check_and_create_verificcation
    end

    def provider_attributes(attributes)
    end

    def check_and_create_verificcation
    end
  end
end
