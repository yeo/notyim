# frozen_string_literal: true

class DestroyCheckWorker
  include Sidekiq::Worker

  # @param sting check id
  def perform(check_id)
    @check = Check.find(check_id)

    delete_incident!
    delete_assertion!
    delete_check_response!
    delete_daily_uptime!
    delete_notification!
  end

  private

  def delete_incident!

  end

  def delete_assertion!

  end

  def delete_check_response!

  end

  def delete_daily_uptime!

  end

  def delete_notification!

  end
end
