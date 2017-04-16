require 'securerandom'

class Invitation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String
  field :verified_at, type: Time
  index({code: 1}, {background: true})

  has_one :team
  belongs_to :invitable, polymorphic: true

end
