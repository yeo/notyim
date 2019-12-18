# frozen_string_literal: true

class Beat
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :check

  field :beat_at, type: DateTime
end

