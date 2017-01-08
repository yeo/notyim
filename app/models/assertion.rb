class Assertion
  include Mongoid::Document
  include Mongoid::Timestamps

  field :subject, type: String
  field :condition, type: String
  field :operand

  SUBJECT_TYPES = %w(
    status
    http.response_body
    http.response_code
    http.response_time
    http.response_headers
    )
  CONDITION_TYPES = {
      :status => {
        :down => 'Down',
        :up => 'Up',
        :slow => 'Slow',
      },

      :http => {
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
end
