# frozen_string_literal: true

module Yeller
  class Message
    attr_reader :subject, :message
    def initialize(subject, message)
      @subject = subject
      @message = message
    end
  end
end
