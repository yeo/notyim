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
    @check.uri = "http://#{@check.uri}" if @check.uri && !@check.uri.start_with?('http')
    @check.user = current.user
    @check.team = current.team
  end
end
