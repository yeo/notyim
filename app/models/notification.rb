# frozen_string_literal: true

class Notification
  include Mongoid::Document

  field :message
  field :kind, type: String
  field :read_at, type: Time

  belongs_to :notifiable, polymorphic: true

  index({ notifiable_id: 1, kind: 1 }, background: true)
end
