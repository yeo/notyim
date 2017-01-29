module Trinity
  module Decorator
    def self.for(model)
      klass = "#{model.class.to_s}Decorator".constantize
      klass.new model
    end
  end
end
