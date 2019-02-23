# frozen_string_literal: true

require 'securerandom'

class Verification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :code, type: String
  field :verified_at, type: Time
  index({ code: 1 }, background: true)

  belongs_to :verifiable, polymorphic: true
  before_save :set_code

  def set_code
    self.code = SecureRandom.hex unless code
  end

  def verify?(input)
    return true if verified_at

    code == input if (Time.now - created_at) <= (24 * 3600)
  end

  # Verify user with input
  def check_to_verify(input)
    return unless verify?(input)

    self.verified_at = Time.now
    save!

    verifiable.verify!
  end
end
