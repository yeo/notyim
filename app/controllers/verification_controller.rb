class VerificationController < ApplicationController
  before_action :set_verification
  protect_from_forgery :except => [:interactive_voice]

  # POST /receivers
  # POST /receivers.json
  def create
    # TODO Impelement this
    render :nothing
  end

  def verify
    if VerificationService.check_to_verify(@verification, params[:code])
      case @verification.verifiable
      when Receiver
        redirect_to receivers_url, flash: { notice: "You have succesflly confirm the contact" }
      else
        if user_signed_in?
          redirect_to dashboard_url, flash: { notice: "You have succesflly confirm the contact" }
        else
          redirect_to root_url, flash: { notice: "You have succesflly confirm the contact" }
        end
      end
    else
      redirect_to root_url, flash: { error: "Invalid code" }
    end
  end

  def interactive_voice
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Hi, this is noty.im. Please enter this verification code on website', voice: 'alice'
      3.times do
        r.Say @verification.code, voice: 'alice'
        r.Pause length: 2
        r.Say "Repeat: ", voice: 'alice'
      end
    end.text

    render inline: response
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_verification
    @verification = Verification.find(params[:id])
  end

end
