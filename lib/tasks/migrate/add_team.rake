namespace :migrate do
  desc "Add missing team"
  task add_team: :environment do
    [Check, Incident, Receiver].each do |klass|
      klass.each do |model|
        if model.team
          next
        end

        puts "Add team for #{model}"

        model.team = model.user.teams.first
        model.save!
      end
    end
  end
end
