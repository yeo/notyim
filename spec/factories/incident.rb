# frozen_string_literal: true
FactoryBot.define do
  factory :incident, class: Incident do
    status 'open'
    error_message 'Request reject'
    locations({ :open => %w(1.1.1.1) })
  end
end
