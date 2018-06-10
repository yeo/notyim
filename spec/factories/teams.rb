# frozen_string_literal: true
FactoryBot.define do
  factory :team do
    name "Team #{SecureRandom.hex}"
  end
end
