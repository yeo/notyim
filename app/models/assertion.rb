class Assertion
  include Mongoid::Document
  include Mongoid::Timestamps

  field :subject, type: String
  field :condition, type: String
  field :operand

  SUBJECT_TYPES = %w(
    tcp.status
    tcp.body
    tcp.response_time

    http.status
    http.body
    http.code
    http.response_time
  )

  CONDITION_TYPES = {
    :tcp => {
      :down => 'Down',
      :up   => 'Up',
      :slow => 'Slow',
    },

    :http => {
      :down => 'Down',
      :up   => 'Up',
      :slow => 'Slow',

      :eq => 'Equal',
      :ne => 'Not equal',
      :gt => 'Greater than',
      :lt => 'Less than',
      :contain => 'Contains',
      :in => 'Includes in'
    }
  }

  belongs_to :check
  has_many :incidents # We don't want to destroy incident when removing assertion

  validates_presence_of :subject, :condition
  validates :subject, :inclusion => { :in => SUBJECT_TYPES }

  def subject_enum
    SUBJECT_TYPES
  end

  def condition_enum
    CONDITION_TYPES
  end

  def ongoing_incident
    @__ongoing_incident ||= incidents.open.first
  end
end
