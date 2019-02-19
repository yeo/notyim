# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :find_check_from_host, only: %i[index update]

  def index
    @beta = true

    # TODO: Fix this logic
    if status_page? && @check&.status_page_enable
      # Signal that this is a public facing - non login view
      @public_view = true
      return render template: 'checks/show', layout: 'status_page'
    end

    current
  end

  private

  def status_page?
    request.host.start_with? 'status'
  end

  def find_check_from_host
    return unless status_page?

    @check = if (found = request.host.match(/status-(.*)\.noty/))
               Check.find(found[1])
             else
               Check.where(status_page_domain: request.host).first
             end
  end
end
