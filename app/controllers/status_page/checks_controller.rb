module StatusPage
  class ChecksController < ApplicationController
    before_action :set_check, :ensure_public

    def show
      render template: "checks/show", layout: 'status_page'
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_check
      @check = Check.find(params[:id])
    end

    def ensure_public
      unless @check.enable_status_page == true
        head :forbidden
      end
    end
  end
end
