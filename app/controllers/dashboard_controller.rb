class DashboardController < ActionController::Base
  layout 'dashboard'
  before_action :authenticate_user!
end
