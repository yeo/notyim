# frozen_string_literal: true

# Trinity
module Trinity
  # A Simple Presentor
  module Presentor
    def present(model, presenter_class = nil)
      klass = presenter_class || "#{model.class}Presenter".constantize
      presenter = klass.new(model)
      if block_given?
        yield(presenter)
      else
        presenter
      end
    end
  end
end
