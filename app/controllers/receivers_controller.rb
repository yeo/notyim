class ReceiversController < DashboardController
  before_action :set_receiver, only: [:show, :edit, :update, :destroy]

  # GET /receivers
  # GET /receivers.json
  def index
    @receivers = current.user.receivers
  end

  # GET /receivers/1
  # GET /receivers/1.json
  def show
  end

  # GET /receivers/new
  def new
    @receiver = Receiver.new(user: current.user)
  end

  # GET /receivers/1/edit
  def edit
  end

  # POST /receivers
  # POST /receivers.json
  def create
    @receiver = Receiver.new(receiver_params)
    @receiver.provider_attributes(params)
    @receiver.user = current.user

    respond_to do |format|
      if ReceiverService.save(@receiver)
        format.html { redirect_to @receiver, notice: 'Receiver was successfully created.' }
        format.json { render :show, status: :created, location: @receiver }
      else
        format.html { render :new }
        format.json { render json: @receiver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /receivers/1
  # PATCH/PUT /receivers/1.json
  def update
    respond_to do |format|
      if @receiver.update(receiver_params)
        format.html { redirect_to @receiver, notice: 'Receiver was successfully updated.' }
        format.json { render :show, status: :ok, location: @receiver }
      else
        format.html { render :edit }
        format.json { render json: @receiver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receivers/1
  # DELETE /receivers/1.json
  def destroy
    @receiver.destroy
    respond_to do |format|
      format.html { redirect_to receivers_url, notice: 'Receiver was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receiver
      @receiver = Receiver.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def receiver_params
      params.require(:receiver).permit(:name, :provider, :handler)
    end
end
