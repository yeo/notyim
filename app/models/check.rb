# frozen_string_literal: true

require 'mongoid/archivable'

class Check
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Archivable
  include Teamify

  TYPE_HTTP = 'http'
  TYPE_TCP  = 'tcp'
  TYPE_HEARTBEAT = 'heartbeat'
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

  index({ created_at: 1, updated_at: 1 }, background: true)
  # index({type: 1}, {background: true})
  index({ status_page_domain: 1 }, background: true)
  index({ user: 1, team: 1 }, background: true)

  validates_presence_of :name, :uri, :type
  validates :type, inclusion: { in: TYPES }
  validates :uri, format: URI.regexp(%w[tcp udp http https])

  def type_enum
    TYPES
  end

  def up?
    incidents.open.empty?
  end

  # Check if the receiver was register to receiver notificatio for this check
  # @param Receiver|String
  def register_receiver?(receiver)
    receiver = receiver.id.to_s if receiver.respond_to? :id

    receivers.include? receiver
  end

  # @return Array<Receiver>
  def fetch_receivers
    return [] if receivers.blank?

    receivers.map do |id|
      Receiver.find(id)
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end.select(&:present?)
  end
end
