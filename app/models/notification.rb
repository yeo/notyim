class Notification
  include Mongoid::Document
  field :content, type: String
  embedded_in :assertion
  embedded_in :check
end
