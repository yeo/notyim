class Incident
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUS_OPEN = 'open'.freeze
  STATUS_CLOSE = 'close'.freeze

  field :status, type: String
  field :acknowledged_at, type: Time
  field :acknowledged_by, type: String

  index({status: 1}, {background: true})
  index({acknowledged_at: 1, acknowledged_by: 1}, {background: true})
  index({created_at: 1}, {background: true})
  after_save :send_alert

  belongs_to :assertion
  # We can get the check via assertio, however, if user delete assertion,
  # we want to retain the incident, hence we add this relation to help us keep
  # track of incident belong to check
  belongs_to :check

  # TODO: queue job
  def send_alert
    if status_changed?
      # TODO: send real alert here
    end
  end
end
