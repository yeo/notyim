require 'securerandom'

class Verification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :code, type: String
  field :verified_at, type: Time

  belongs_to :verifiable, polymorphic: true
  before_save :set_code

  def set_code
    if !self.code
      self.code = SecureRandom.hex
    end
  end

  def verify?(input)
    return true if self.verified_at

    if (Time.now - created_at) <= (24 * 3600)
      code == input
    end
  end

  # Verify user with input
  def check_to_verify(input)
    if verify?(input)
      self.verified_at = Time.now
      self.save!

      self.verifiable.verify!
    end
  end
end
