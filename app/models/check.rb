class Check
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  TYPE_HTTP = 'http'.freeze
  TYPE_TCP  = 'tcp'.freeze
  TYPE_HEARTBEAT = 'hearbeat'.freeze
  TYPES = [TYPE_HTTP, TYPE_TCP, TYPE_HEARTBEAT].freeze

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

  def up?
    incidents.open.length == 0
  end

  # Check if the receiver was register to receiver notificatio for this check
  # @param Receiver|String
  def register_receiver?(r)
    return false if !receivers

    r = if r.respond_to? :id
      r.id.to_s
    end

    receivers.include? r
  end

  # @return Array<Receiver>
  def fetch_receivers
    if receivers.empty?
      return []
    end

    receivers.map { |id| Receiver.find(id) }
  end
end
