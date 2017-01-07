module Mongoid
  module Verifiable
    def self.included(base)
      base.field :require_verify, type: Mongoid::Boolean, default: true
      base.field :verified, type: Mongoid::Boolean
      base.has_many :verifications, as: :verifiable, dependent: :destroy

      #base.extend ClassMethod
    end

    def verify!
      self.verified = true
      self.save!
    end

    def last_verification
      self.verifications.desc(:id).limit(1).first
    end
  end
end
