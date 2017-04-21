class StripeToken
  include Mongoid::Document
  include Mongoid::Timestamps
  include Teamify

  field :token, type: String
  field :customer, type: String

  belongs_to :user

  scope :latest, ->() { desc(:id).first }
end
