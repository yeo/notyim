class TeamMembership
  ROLES = %w(editor admin).freeze

  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :team

  field :role, type: String
  validates :role, :inclusion => { :in => ROLES }
end
