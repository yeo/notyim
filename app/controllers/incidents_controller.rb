class IncidentsController < DashboardController
  before_action :set_incident, only: [:show, :edit, :update, :destroy]

  # GET /incidents
  # GET /incidents.json
  def index
    case params[:status]
    when 'close'.freeze
      @incidents = current.user.incidents.not_archived.close.desc(:id).page(params[:page])
    else
      @incidents = current.user.incidents.not_archived.open.desc(:id).page(params[:page])
    end
  end

  # GET /incidents/1
  # GET /incidents/1.json
  def show
  end

  # GET /incidents/new
  def new
    unless params[:check_id]
      head 400
      return
    end

    @incident = Incident.new(check: Check.find(params[:check_id]))
  end

  # GET /incidents/1/edit
  def edit
  end

  # POST /incidents
  # POST /incidents.json
  def create
    @incident = Incident.new(incident_params)

    respond_to do |format|
      if @incident.save
        format.html { redirect_to @incident, notice: 'Incident was successfully created.' }
        format.json { render :show, status: :created, location: @incident }
      else
        format.html { render :new }
        format.json { render json: @incident.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incidents/1
  # PATCH/PUT /incidents/1.json
  def update
    respond_to do |format|
      if @incident.update(incident_params)
        format.html { redirect_to @incident, notice: 'Incident was successfully updated.' }
        format.json { render :show, status: :ok, location: @incident }
      else
        format.html { render :edit }
        format.json { render json: @incident.errors, status: :unprocessable_entity }
      end
    end
  end

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
end
