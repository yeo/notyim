class Subscription
  include Mongoid::Document
  include Mongoid::Timestamps
  include Teamify
  STATUS_GENERATED = "generated"
  STATUS_ACTIVED = "actived"

  field :start_at, type: Time
  field :expire_at, type: Time
  field :plan, type: String

  # Status is ENUM
  field :status, type: String

  belongs_to :user
  index({user: 1, status: 1}, {background: true})
end
