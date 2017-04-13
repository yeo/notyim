class BotAccount
  include Mongoid::Document
  include Mongoid::Timestamps

  field :bot_uuid
  field :address
  field :token
  field :link_verification_code

  # Meta data about this bot
  field :meta

  index({bot_uuid: 1}, {background: true})
  index({token: 1}, {background: true})

  validates_uniqueness_of :bot_uuid
  validates_uniqueness_of :token

  belongs_to :user, optional: true

  before_create :set_token

  def set_token
    unless self.token
      self.token = SecureRandom.hex
    end
  end
end
