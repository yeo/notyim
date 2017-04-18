require 'mongoid/archivable'

class Team
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Archivable

  field :name, type: String
  belongs_to :user
  has_many :invites, as: :invitable
  has_many :team_memberships

  scope :mine, ->(u) { where(user: u) }

  def format_as_json
    {id: self.id.to_s, name: name}
  end
end
