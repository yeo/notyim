module Teamify
  extend ActiveSupport::Concern

  included do
    belongs_to :team
    scope :of_team, ->(t) { where(team: t) }

    index({team: 1}, {background: true})
  end
end
