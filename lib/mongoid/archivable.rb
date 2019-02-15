# frozen_string_literal: true

module Mongoid
  module Archivable
    def self.included(base)
      base.field :archived, type: Mongoid::Boolean, default: false
      base.field :archived_at, type: Time
      base.scope :not_archived, -> { where(archived: false) }
      base.index({ archived: 1, archived_at: 1 }, background: true)
    end

    def archive
      self.archived = true
      self.archived_at = Time.now
      save!
    end
  end
end
