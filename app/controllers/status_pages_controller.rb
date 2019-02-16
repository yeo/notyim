# frozen_string_literal: true

class StatusPagesController < DashboardController
  before_action :set_check

  def create
    @check.status_page_enable = true
    @check.status_page_domain = params[:check][:status_page_domain]

    if @check.save
      redirect_to edit_check_path(@check), notice: t('status_page.success_enable')
    else
      redirect_to edit_check_path(@check), error: t('status_page.error_enable')
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_check
    @check = Check.find(params[:check][:id])
    head :forbidden unless CheckPolicy.can_manage?(@check, current.user)
  end
end
