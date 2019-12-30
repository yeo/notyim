# frozen_string_literal: true

class ChecksController < DashboardController
  before_action :set_check, only: %i[show edit update destroy]

  def index
    @checks = current.user.checks.where(team: current.team)
  end

  def show
    load_response_log
  end

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
    if @check.update(format_check_params)
      redirect_to @check, notice: 'Check was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    DestroyCheckWorker.perform_async(@check.id.to_s)
    redirect_to checks_url, notice: t('check.destroy_schedule')
  end

  private

  def load_response_log
    @response_log = @check.check_logs.order_by(_id: -1).limit(30).lazy.map { |d| d.response }
  end

  def set_check
    @check = Check.find(params[:id])

    return unless @check.persisted?
    return if CheckPolicy.can_manage?(@check, current.user)

    @check = nil
    head :forbidden
  end

  def check_params
    params.require(:check).permit(:name, :uri, :type, :require_auth,
                                  :http_method, :body, :body_type,
                                  :auth_username, :auth_password, :http_headers)
  end

  def build_check
    @check = Check.new(format_check_params)
    auto_prefix
    @check.user = current.user
    @check.team = current.team
  end

  def format_check_params
    input = check_params

    if input['http_headers'].is_a?(String)
      input['http_headers'] = input['http_headers'].split("\n").map(&:strip).reject(&:empty?)
    end

    input
  end

  def auto_prefix
    case @check.type
    when Check::TYPE_HTTP
      @check.uri = "http://#{@check.uri}" unless @check.uri.start_with?('http')
    when Check::TYPE_TCP
      @check.uri = "tcp://#{@check.uri}" unless @check.uri.start_with?('tcp')
    when Check::TYPE_HEARTBEAT
      # In heartbeat check, we will automaticallt generate this id
      @check.uri = "https://gaia.noty.im/beat/#{@check.id}"
    end
  end
end
