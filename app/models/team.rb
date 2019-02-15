# frozen_string_literal: true

require 'mongoid/archivable'

class Team
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Archivable

  field :name, type: String
  belongs_to :user
  has_many :invites, as: :invitable, class_name: 'Invitation'
  has_many :team_memberships, dependent: :destroy
  has_one :credit, dependent: :destroy

  scope :mine, ->(u) { where(user: u) }
  validates_presence_of :name

  def format_as_json
    { id: id.to_s, name: name }
  end
end
