require 'yeller'

class Receiver
  include Mongoid::Document
  include Yeller::Processor

  field :provider, type: String
  field :name, type: String
  field :handler, type: String
  field :require_verify, type: Mongoid::Boolean, default: true
  field :verified, type: Mongoid::Boolean

  field :provider_params

  belongs_to :user, index: true

  validates_presence_of :provider, :name, :handler
  validates :provider, :inclusion => { :in => Yeller::Provider.providers.map(&:identity).map(&:downcase) }
end
