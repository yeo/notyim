# frozen_string_literal: true

class CheckLog
  include Mongoid::Document
  include Mongoid::Timestamps::Created


  field :response, type: Hash

  field :region, type: String
  field :agent, type: String
  field :ip, type: String

  belongs_to :check

  index({check_id: -1}, {background: true})
  index({created_at: 1}, {expire_after_seconds: 3600})
end
