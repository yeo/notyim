module Mongoid
  module Archivable
    def self.included(base)
      base.field :archived, type: Mongoid::Boolean, default: false
      base.field :archived_at, type: Time
    end

    def archive
      self.archived = true
      self.archived_at = Time.now
      self.save!
    end
  end
end
