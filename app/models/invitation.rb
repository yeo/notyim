require 'securerandom'

class Invitation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String
  field :accepted_at, type: Time
  field :code, type: String

  index({code: 1}, {background: true})
  index({accepted_at: 1}, {background: true})

  belongs_to :invitable, polymorphic: true
  belongs_to :user

  before_save :set_code
  scope :pending, ->() { where(accepted_at: {:$eq => nil}) }

  def set_code
    if !self.code
      self.code = SecureRandom.hex
    end
  end
end
