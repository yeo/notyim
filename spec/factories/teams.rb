FactoryBot.define do
  factory :team do
    name "Team #{SecureRandom.hex}"
  end
end
