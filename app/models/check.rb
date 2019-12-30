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

  HTTP_METHOD_HEAD = 'HEAD'
  HTTP_METHOD_GET = 'GET'
  HTTP_METHOD_POST = 'POST'
  HTTP_METHOD_PUT = 'PUT'
  HTTP_METHODS = [
    HTTP_METHOD_HEAD,
    HTTP_METHOD_GET,
    HTTP_METHOD_POST,
    HTTP_METHOD_PUT,
  ].freeze

  BODY_TYPES = %w(none raw json form).freeze

  field :name, type: String
  field :uri, type: String
  field :type, type: String
  field :receivers, type: Array

  field :uptime_1hour, default: 100
  field :uptime_1day, default: 100
  field :uptime_1month, default: 100

  field :status_page_enable, type: Boolean
  field :status_page_domain

  # Check payload
  field :http_method, type: String
  field :body_type, type: String
  field :body, type: String
  field :http_headers, type: Hash
  field :require_auth, type: Boolean
  field :auth_username, type: String
  field :auth_password, type: String

  belongs_to :user

  has_many :assertions, dependent: :destroy
  has_many :incidents, dependent: :destroy
  has_many :check_logs, dependent: :destroy
  has_one :daily_uptime, dependent: :destroy

  index({ created_at: 1, updated_at: 1 }, background: true)
  # index({type: 1}, {background: true})
  index({ status_page_domain: 1 }, background: true)
  index({ user: 1, team: 1 }, background: true)

  validates_presence_of :name, :uri, :type
  validates :type, inclusion: { in: TYPES }
  validates :uri, format: URI.regexp(%w[tcp udp http https])
  validates :body_type, inclusion: { in: BODY_TYPES }, allow_nil: true
  validates :http_method, inclusion: { in: HTTP_METHODS }, allow_nil: true

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

  # TODO: Extract this method out
  def http_headers_to_text_field
    http_headers&.map { |kv| kv.join '=' }.join("\n")
  end
end
