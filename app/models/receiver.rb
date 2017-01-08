require 'yeller'
require 'mongoid/verifiable'

class Receiver
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Mongoid::Verifiable
  include Yeller::Processor

  field :provider, type: String
  field :name, type: String
  field :handler, type: String

  field :provider_params

  belongs_to :user, index: true
  before_create :set_verification

  validates_presence_of :provider, :name, :handler
  validates :provider, :inclusion => { :in => Yeller::Provider.providers.keys }

  index({provider: 1}, {background: true})
  index({handler: 1}, {background: true})
  index({handler: 1, user_id: 1}, {background: true})
  validates :handler, uniqueness: { scope: [:user, :provider] }

  # Return provider class that hold utilities method for this provider
  def provider_class
    @__klass ||= Yeller::Provider.class_of(provider)
  end

  # Callback to set verification class depend on provider
  def set_verification
    if provider_class.require_verify?
      self.require_verify = true
      self.verified = false
    end
  end

  # TODO: Let's see why we cannot use after_save callback here
  # because it keeps triggering callback and create unlimited amout of verification
  # until stack deep limit is reached
  def create_verification!
    if self.require_verify?
      Verification.create!(code: provider_class.generate_code(self), verifiable: self)
    end
  end
end
