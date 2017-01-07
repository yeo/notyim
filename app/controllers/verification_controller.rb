class VerificationController < ApplicationController
  before_action :set_verification

  # POST /receivers
  # POST /receivers.json
  def create
    # TODO Impelement this
    render :nothing
  end

  def verify
    if @verification.check_to_verify(params[:code])
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_verification
      @verification = Verification.find(params[:id])
    end

end
