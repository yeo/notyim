# frozen_string_literal: true

module Trinity
  module Decorator
    def decorate(model, klass = nil)
      klass ||= "#{model.class}Decorator".constantize
      decorator = klass.new(model)
      if block_given?
        yield(decorator)
      else
        decorator
      end
    end
  end
end
