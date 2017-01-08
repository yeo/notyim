class Check
  include Mongoid::Document
  include Mongoid::Timestamps

  TYPES = %w(http tcp heartbeat).freeze

  field :name, type: String
  field :uri, type: String
  field :type, type: String
  field :receivers, type: Array

  belongs_to :user, index: true
  belongs_to :team, index: true
  has_many :assertions, dependent: :destroy
  has_many :incidents, dependent: :destroy

  index({type: 1}, {background: true})
  validates_presence_of :name, :uri, :type
  validates :type, :inclusion => { :in => TYPES }
  validates :uri, :format => URI::regexp(%w(http https))

  def type_enum
    TYPES
  end

  # Check if the receiver was register to receiver notificatio for this check
  # @param Receiver|String
  def register_receiver?(r)
    r = if r.respond_to? :id
      r.id.to_s
    end

    receivers.include? r
  end
end
