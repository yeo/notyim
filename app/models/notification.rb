class Notification
  include Mongoid::Document

  field :subject, type: String
  field :content, type: String

  belongs_to :assertion
end
