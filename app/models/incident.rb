require 'mongoid/archivable'

class Incident
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Archivable

  STATUS_OPEN = 'open'.freeze
  STATUS_CLOSE = 'close'.freeze

  field :status, type: String
  field :acknowledged_at, type: Time
  field :acknowledged_by, type: String

  field :error_message, type: String

  index({status: 1}, {background: true})
  index({acknowledged_at: 1, acknowledged_by: 1}, {background: true})
  index({created_at: 1}, {background: true})

  belongs_to :assertion
  belongs_to :check
  belongs_to :user
  has_many :check_responses, dependent: :destroy

  scope :open, -> () { where(status: STATUS_OPEN).desc(:id) }

  def open?
    status == STATUS_OPEN
  end

  def close?
    !open?
  end
end
