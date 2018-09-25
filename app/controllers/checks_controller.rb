class ChecksController < DashboardController
  before_action :set_check, only: [:show, :edit, :update, :destroy]

  def index
    @checks = current.user.checks.where(team: current.team)
  end

  def show
  end

  def new
    @check = Check.new
  end

  def edit
  end

  def create
    @check = Check.new(check_params)
    @check.uri = "http://#{@check.uri}" if @check.uri && !@check.uri.start_with?('http')
    @check.user = current.user
    @check.team = current.team

    respond_to do |format|
      if @check.save
        format.html { redirect_to @check, notice: 'Check was successfully created.' }
        format.json { render :show, status: :created, location: @check }
      else
        format.html { render :new }
        format.json { render json: @check.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
		if @check.update(check_params)
			redirect_to @check, notice: 'Check was successfully updated'
		else
		  render :edit
		end
  end

  def destroy
    @check.destroy
    redirect_to checks_url, notice: 'Check was successfully destroyed.'
  end

  private
	def set_check
		@check = Check.find(params[:id])
		if @check.persisted?
			unless CheckPolicy::can_manage?(@check, current.user)
				@check = nil
				head :forbidden
			end
			#redirect_to root_path, :flash => { :error => "Insufficient rights!" } unless CheckPolicy::can_manage?(@check, current.user)
		end
	end

	def check_params
		params.require(:check).permit(:name, :uri, :type)
	end
end
