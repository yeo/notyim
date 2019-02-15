# frozen_string_literal: true

class AutoCreateAssertionWorker
  include Sidekiq::Worker

  # Find all checks that has no assertion and automatically create an assertion for them
  def perform(duration = 5)
    Check.where(created_at: { :$gt => duration.minute.ago }, :updated_at.lt => 2.minute.ago).pluck(:id).each do |id|
      puts "Auto create for #{id}"
      CheckService.auto_create_assertions(id)
    end
  end
end
