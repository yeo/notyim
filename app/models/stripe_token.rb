class StripeToken
  include Mongoid::Document
  include Mongoid::Timestamps

  field :source, type: String
  field :email, type: String
  field :customer, type: String

  belongs_to :user
end
