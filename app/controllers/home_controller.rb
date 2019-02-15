# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    # TODO: Fix this logic
    if request.host.start_with? 'status'
      @public_view = true

      @check = if found = request.host.match(/status-(.*)\.noty/)
                 Check.find(found[1])
               else
                 Check.where(status_page_domain: request.host).first
               end

      if @check
        if @check.status_page_enable
          render template: 'checks/show', layout: 'status_page'
          return
        end
      end
    end

    current
    @beta = true
  end
end
