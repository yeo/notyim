# frozen_string_literal: true

class CheckLog
  include Mongoid::Document

  field :response, type: Hash

  field :region, type: String
  field :agent, type: String

  belongs_to :check

  index({check_id: -1}, {background: true})
end
