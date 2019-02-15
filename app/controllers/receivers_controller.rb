# frozen_string_literal: true

class ReceiversController < DashboardController
  before_action :set_receiver, only: %i[show edit update destroy]

  def index
    @receivers = current.user.receivers
  end

  def new
    @receiver = Receiver.new(user: current.user, team: current.team)
  end

  def edit; end

  def create
    @receiver = Receiver.new(receiver_params)
    @receiver.provider_attributes(params)
    @receiver.user = current.user
    @receiver.team = current.team

    if ReceiverService.save(@receiver)
      redirect_to receivers_path(anchor: @receiver.id.to_s), notice: 'Receiver was successfully created.'
    else
      render :new
    end
  end

  def update
    if @receiver.update(receiver_params)
      redirect_to receivers_path(anchor: @receiver.id.to_s), notice: 'Receiver was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @receiver.destroy
    redirect_to receivers_url, notice: 'Receiver was successfully destroyed'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_receiver
    @receiver = Receiver.find(params[:id])
    return if !@receiver.persisted? || ReceiverPolicy.can_manage?(@receiver, current.user)

    @receiver = nil
    head :forbidden
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def receiver_params
    params.require(:receiver).permit(:name, :provider, :handler)
  end
end
