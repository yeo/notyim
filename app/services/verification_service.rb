class VerificationService
  # CHeck to see whether we can verify
  def self.check_to_verify(verification, input)
    result = verification.check_to_verify(input)
    if result
      # Send acknowledge
      receiver = verification.verifiable
      receiver.provider_class.acknowledge_verification(receiver)
      true
    else
      false
    end
  end

  # Resend verification code
  # @param Verification
  def self.generate(receiver)
    verification = receiver.last_verification

    if verification && ((Time.now - verification.created_at) > 24.hour)
      verification.destroy
    end

    verification = receiver.create_verification!
    receiver.provider_class.create_verification_request!(receiver)
  end

  # Render twilio response
  def self.render_twilio_response(verification)
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Hi, this is noty.im. Here are 6 ditgit verification code', voice: 'alice'
      3.times do |i|
        verification.code.to_s.split('').each do |c|
          r.Say c, voice: 'alice'
          r.Pause length: 1
        end
        if i <= 1
          r.Say "I will repeat #{2 - i} more time", voice: 'alice'
        end
        r.Pause length: 1
      end
    end

    response.text
  end
end
