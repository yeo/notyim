# frozen_string_literal: true

class StatusPagesController < DashboardController
  before_action :set_check

  def create
    @check.status_page_enable = true
    @check.status_page_domain = params[:check][:status_page_domain]

    respond_to do |format|
      if @check.save
        format.html { redirect_to edit_check_path(@check), notice: 'Publci status page enabled succesfully. Make sure your point your domain to our CNAME st.noty.im' }
        format.json { render :show, status: :created, location: @check }
      else
        format.html { redirect_to edit_check_path(@check), error: 'Cannot enable public page' }
        format.json { render json: @check.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_check
    @check = Check.find(params[:check][:id])
    head :forbidden unless CheckPolicy.can_manage?(@check, current.user)
  end
end
