# frozen_string_literal: true

class AuditLog
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  SYSTEM_COMPOSER = 'system'

  belongs_to :auditable, polymorphic: true

  # auditable id is enough, no need for extra type column to save index size
  # the object id is unique enough
  index({ auditable: 1, created_at: 1, event: 1 }, background: true)
  index({ composer: 1 }, background: true)

  field :event
  field :snapshot
  field :composer

  validates_presence_of :old_snapshot
  validates_presence_of :snapshot
  validates_presence_of :event
  validates_presence_of :composer

  # of which object
  scope :of, ->(u) { where(auditable: u) }
  # for which event
  scope :for, ->(event) { where(event: event) }

  def self.cleanup!
    where(:created_at.lt => 6.weeks.ago).delete
  end

  # CHeck whether we have an event for this
  #
  # @param string|symbol
  # @param object model object
  # @param time created_at
  #
  # @return bool
  def self.has?(event, on, created_at)
    where(auditable: on, event: event, created_at: { '$gt' => created_at }).count >= 1
  end

  # Compose an log
  # @param object target
  # @param oject new value
  # @param object old value
  # @param string event
  # @param object who trigger this
  def self.compose(target, old_value, new_value, event:, trigger:)
    create!(auditable: target,
            snapshot: new_value,
            old_snapshot: old_value,
            event: event,
            composer: trigger)
  end
end
