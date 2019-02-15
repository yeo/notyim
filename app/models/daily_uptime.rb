# frozen_string_literal: true

class DailyUptime
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :check
  field :histories, type: Array, default: []

  index({ check_id: 1 }, background: true)
end
