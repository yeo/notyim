class TeamsController < DashboardController
  before_action :my_teams
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  # GET /teams
  # GET /teams.json
  def index
    @team = @teams.first
    @team_membership = TeamMembership.new(team: @team)
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @team_membership = TeamMembership.new(team: @team)

    render 'teams/index'
  end

  # GET /teams/new
  def new
    @team = Team.new(user: current.user)
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)
    @team.user = current_user
    if @team.save
      redirect_to teams_path, notice: 'Team was succesfully created.'
    else
      redirect_to teams_path, alert: 'Team fail to create'
    end

    #respond_to do |format|
    #  if @team.save
    #    format.html { redirect_to @team, notice: 'Team was successfully created.' }
    #    format.json { render :show, status: :created, location: @team }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @team.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def my_teams
      @teams = Team.mine(current.user)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id]) if params[:id]

      if @team.persisted?
        head :forbidden unless TeamPolicy::can_manage?(@team, current.user)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name)
    end
end
