class Credit
  include Mongoid::Document
  include Mongoid::Timestamps
  include Teamify

  field :sms, type: Integer
  field :voice_second, type: Integer

  belongs_to :user
end
