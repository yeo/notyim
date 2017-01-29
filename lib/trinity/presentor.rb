module Trinity
  module Presentor
    def self.for(model)
      klass = "#{model.class.to_s}Presentor"
      klass.new model
    end
  end
end
