# frozen_string_literal: true

class ChecksController < DashboardController
  before_action :set_check, only: %i[show edit update destroy]

  def index
    @checks = current.user.checks.where(team: current.team)
  end

  def show; end

  def new
    @check = Check.new
  end

  def edit; end

  def create
    build_check

    if @check.save
      redirect_to @check, notice: t('dashboard.check_created')
    else
      render :new
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

    return unless @check.persisted?
    return if CheckPolicy.can_manage?(@check, current.user)

    @check = nil
    head :forbidden
  end

  def check_params
    params.require(:check).permit(:name, :uri, :type)
  end

  def build_check
    @check = Check.new(check_params)
    @check.uri = auto_prefix
    @check.user = current.user
    @check.team = current.team
  end

  def auto_prefix
    case @check.type
    when Check::TYPE_HTTP
      "http://#{@check.uri}" unless @check.uri.start_with?('http')
    when Check::TYPE_TCP
      "tcp://#{@check.uri}" unless @check.uri.start_with?('tcp')
    when Check::TYPE_HEARTBEAT
      # In heartbeat check, we will automaticallt generate this id
      "https://gaia.noty.im/beat/#{@check.id}"
    end
  end
end
