# frozen_string_literal: true

class TeamMembership
  ROLE_EDITOR = 'editor'
  ROLES = %w[editor admin].freeze

  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :team

  field :role, type: String
  validates :role, inclusion: { in: ROLES }
end
