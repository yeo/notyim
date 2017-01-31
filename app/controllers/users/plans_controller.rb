class Users::PlansController < DashboardController
  def show
    @balance = 18#current.user.balance
    @plan    = 18 #current.user.plan
  end
end
