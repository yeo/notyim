# frozen_string_literal: true

class ApiToken
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :token, type: String
  belongs_to :user

  index({ user: 1 }, background: true)
end
