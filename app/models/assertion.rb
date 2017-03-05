require 'mongoid/archivable'

class Assertion
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Archivable

  field :subject, type: String
  field :condition, type: String
  field :operand

  # Part before dot has to match
  # @reference Check::Types
  SUBJECT_TYPES = {
    "#{Check::TYPE_TCP}.status" => 'status',
    "#{Check::TYPE_TCP}.body" =>  'response body',
    "#{Check::TYPE_TCP}.response_time" => 'response time',

    "#{Check::TYPE_HTTP}.status" => 'status',
    "#{Check::TYPE_HTTP}.body" => 'response body',
    "#{Check::TYPE_HTTP}.code" => 'response code',
    "#{Check::TYPE_HTTP}.response_time" => 'response time',
  }.freeze

  # Condition key has to match with check type:
  # @reference Check::Types
  CONDITION_TYPES = {
    Check::TYPE_TCP => {
      :down => 'Down',
      :up   => 'Up',
    },

    Check::TYPE_HTTP => {
      :down => 'Down',
      :up   => 'Up',

      :eq => 'Equal',
      :ne => 'Not equal',
      :gt => 'Greater than',
      :lt => 'Less than',
      :contain => 'Contains',
      :in => 'Includes in'
    }
  }.freeze

  DECISION_TREE = [
  ]

  belongs_to :check
  has_many :incidents, dependent: :destroy # We don't want to destroy incident when removing assertion

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
