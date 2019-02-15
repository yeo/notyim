# frozen_string_literal: true

namespace :migrate do
  desc 'Add missing team'
  task add_team: :environment do
    [Check, Incident, Receiver, BotAccount, ChargeTransaction, Credit, Subscription, StripeToken].each do |klass|
      klass.each do |model|
        next if model.team

        puts "Add team for #{model}"
        puts "Original team #{model.team || 'none'} -> #{model.user.teams.first}"
        model.team = model.user.teams.first
        model.save!
      end
    end
  end
end
