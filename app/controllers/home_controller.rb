class HomeController < ApplicationController
  def index
    # TODO: Fix this logic
    if request.host.start_with? 'status'
      @public_view = true

      if found = request.host.match(/status-(.*)\.noty/)
        @check = Check.find(found[1])
      else
        @check = Check.where(status_page_domain: request.host).first
      end

      if @check
        if @check.status_page_enable
          render template: "checks/show", layout: 'status_page'
          return
        end
      end
    end

    current
    @beta = true
    @botname = Rails.configuration.telegram_bot
  end
end
