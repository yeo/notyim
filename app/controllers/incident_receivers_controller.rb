# frozen_string_literal: true

class IncidentReceiversController < DashboardController
  before_action :set_check

  def create
    if CheckService.register_receivers(@check, params['contact_receivers'])
      redirect_back(fallback_location: root_path, notice: 'Succesfully update notification list')
    else
      redirect_back(fallback_location: root_path, notice: 'An error occurs')
    end
  end

  private

  def set_check
    @check = Check.find(params[:check_id])

    head :forbidden unless CheckPolicy.can_manage?(@check, current.user)
  end
end
