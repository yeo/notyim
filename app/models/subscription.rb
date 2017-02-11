class Subscription
  include Mongoid::Document
  include Mongoid::Timestamps

  field :start_at, type: Time
  field :expire_at, type: Time
  field :plan, type: String

  belongs_to :user, index: true
end
