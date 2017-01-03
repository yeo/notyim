class Check
  include Mongoid::Document
  include Mongoid::Timestamps

  TYPES = %w(http tcp heartbeat).freeze

  field :name, type: String
  field :uri, type: String
  field :type, type: String

  belongs_to :user, index: true
  belongs_to :team, index: true

  index({type: 1}, {background: true})
  validates_presence_of :name, :uri, :type
  validates :type, :inclusion => { :in => TYPES }
  validates :uri, :format => URI::regexp(%w(http https))

  def type_enum
    TYPES
  end
end
