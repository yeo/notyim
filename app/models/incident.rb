# frozen_string_literal: true

require 'mongoid/archivable'

class Incident
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Archivable
  include Teamify

  STATUS_OPEN = 'open'
  STATUS_CLOSE = 'close'
  STATUS_PARTIAL = 'partial'

  field :status, type: String
  field :acknowledged_at, type: Time
  field :acknowledged_by, type: String
  field :closed_at, type: Time

  field :error_message, type: String
  field :locations, type: Hash, default: { open: [], close: [] }

  index({ team: 1, status: 1 }, background: true)
  index({ acknowledged_at: 1, acknowledged_by: 1 }, background: true)
  index({ created_at: 1 }, background: true)
  # TODO: add custom validation to prevent multiple open for a check and assertion

  belongs_to :assertion
  belongs_to :check
  belongs_to :user
  has_many :check_responses, dependent: :destroy
  has_many :notifications, as: :notifiable

  scope :open, -> { where(status: STATUS_OPEN).desc(:id) }
  scope :close, -> { where(status: STATUS_CLOSE).desc(:id) }
  scope :partial, -> { where(status: STATUS_PARTIAL).desc(:id) }

  scope :of_team, ->(team) { where(team: team) }

  def open?
    status == STATUS_OPEN
  end

  def close?
    status == STATUS_CLOSE
  end
end
