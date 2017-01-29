module Yeller
  class Message

    attr_reader :subject, :message
    def initialize(s, m)
      @subject = s
      @message = m
    end
  end
end
