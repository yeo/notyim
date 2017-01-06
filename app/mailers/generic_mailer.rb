class GenericMailer < ApplicationMailer
  default from: ENV['SMTP_FROM']

  def general(receiver, content, subject)
    mail(to: receiver, body: content, content_type: 'text/html', subject: subject)
  end
end
