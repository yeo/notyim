# frozen_string_literal: true

class IncidentVoicesController < ApplicationController
  before_action :set_incident
  protect_from_forgery except: [:interactive_voice]

  # Return twilioml for Twilio
  def show
    render inline: Yeller::Provider::Phone.incident_twilio_notification(@incident)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_incident
    @incident = Incident.find(params[:id])
  end
end
