# frozen_string_literal: true

# Mongoid patch
module Mongoid
  # Verifiable for thing we can trigger verification
  module Verifiable
    def self.included(base)
      base.field :require_verify, type: Mongoid::Boolean, default: true
      base.field :verified, type: Mongoid::Boolean
      base.has_many :verifications, as: :verifiable, dependent: :destroy

      # base.extend ClassMethod
    end

    def verify!
      self.verified = true
      save!
    end

    def last_verification
      verifications.desc(:id).limit(1).first
    end
  end
end
