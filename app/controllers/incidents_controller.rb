# frozen_string_literal: true

class IncidentsController < DashboardController
  before_action :set_incident, only: %i[show edit update destroy]

  # GET /incidents
  # GET /incidents.json
  def index
    @incidents = case params[:status]
                 when 'close'
                   close_incidents
                 else
                   open_incidents
                 end
  end

  # GET /incidents/1
  # GET /incidents/1.json
  def show; end

  # DELETE /incidents/1
  # DELETE /incidents/1.json
  def destroy
    @incident.destroy
    respond_to do |format|
      format.html { redirect_to incidents_url, notice: 'Incident was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_incident
    @incident = Incident.find(params[:id])
    abort(400) unless @incident
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def incident_params
    params.require(:incident).permit(:check_id, :status, :acknowledged_at)
  end

  def close_incidents
    current.user.incidents.not_archived.close.desc(:id).page(params[:page])
  end

  def open_incidents
    current.user.incidents.not_archived.open.desc(:id).page(params[:page])
  end
end
