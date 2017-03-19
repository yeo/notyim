class BotAccount
  include Mongoid::Document
  include Mongoid::Timestamps

  field :bot_uuid
  field :address
  field :token
  field :link_verification_code

  index({bot_uuid: 1}, {background: true})
  index({token: 1}, {background: true})

  validates_uniqueness_of :bot_uuid
  validates_uniqueness_of :token

  belongs_to :user, optional: true

  before_create :set_uuid
  before_create :set_token

  def set_token
    unless self.token
      self.token = SecureRandom.hex
    end
  end

  def set_uuid
    unless self.bot_uuid
      self.bot_uuid = [address['channelId'], address['user']['id']].join("_")
    end
  end
end
