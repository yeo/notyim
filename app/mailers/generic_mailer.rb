class GenericMailer < ApplicationMailer
  def general(receiver, content, subject)
    mail(to: receiver, body: content, content_type: 'text/html', subject: subject)
  end
end
