# frozen_string_literal: true

module ChargesHelper
  def stripe_publish_key
    Rails.configuration.stripe[:publishable_key]
  end
end
