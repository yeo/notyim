# frozen_string_literal: true

class VerificationController < ApplicationController
  before_action :set_verification
  protect_from_forgery except: [:interactive_voice]

  # POST /receivers
  # POST /receivers.json
  def create
    # TODO: Impelement this
    return head :bad_request if params[:receiver_id].empty?

    # TODO: check permission
    Receiver.find(params[:reciever_id])

    render :nothing
  end

  # Resend verification. We may re-create if old one is expire
  def resend
    if VerificationService.generate(@verification.verifiable)
      redirect_back fallback_location: root_path, notice: 'Verification is resend.'
    else
      redirect_back fallback_location: root_path, alert: 'An error has occure. Please try again'
    end
  end

  def verify
    if VerificationService.check_to_verify(@verification, params[:code])
      case @verification.verifiable
      when Receiver
        redirect_to receivers_url, flash: { notice: 'You have succesflly confirm the contact' }
      else
        if user_signed_in?
          redirect_to dashboard_url, flash: { notice: 'You have succesflly confirm the contact' }
        else
          redirect_to root_url, flash: { notice: 'You have succesflly confirm the contact' }
        end
      end
    else
      redirect_to root_url, flash: { error: 'Invalid code' }
    end
  end

  # Return twilioml for Twilio
  def interactive_voice
    render inline: VerificationService.render_twilio_response(@verification)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_verification
    @verification = Verification.find(params[:id])
  end
end
