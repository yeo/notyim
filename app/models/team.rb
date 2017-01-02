class Team
  include Mongoid::Document
  field :name, type: String
  belongs_to :user

  scope :mine, ->(u) { where(user: u) }
end
