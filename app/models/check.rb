require 'mongoid/archivable'

class Check
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Archivable
  include Teamify

  TYPE_HTTP = 'http'.freeze
  TYPE_TCP  = 'tcp'.freeze
  TYPE_HEARTBEAT = 'heartbeat'.freeze
  TYPES = [TYPE_HTTP, TYPE_TCP, TYPE_HEARTBEAT].freeze

  field :name, type: String
  field :uri, type: String
  field :type, type: String
  field :receivers, type: Array

  field :uptime_1hour, default: 100
  field :uptime_1day, default: 100
  field :uptime_1month, default: 100

  field :status_page_enable, type: Boolean
  field :status_page_domain

  belongs_to :user
  has_many :assertions, dependent: :destroy
  has_many :incidents, dependent: :destroy
  has_one :daily_uptime, dependent: :destroy

  index({type: 1}, {background: true})
  index({status_page_domain: 1}, {background: true})
  index({user: 1, team: 1}, {background: true})

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

    if _receivers = receivers.map { |id| Receiver.find(id) rescue nil }.select { |d| d.present? }
      _receivers
    end
  end
end
