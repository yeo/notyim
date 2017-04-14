module Trinity
  #Encapsulate current request data
  class Current
    attr_accessor :team, :user

    def initialize(user)
      @user = user
      # TODO Revisit this when we rolledout team support
      @team = @user.teams.first if @user.present?
    end

    def signed_in?
      user.present?
    end

    class << self
      def instance(user)
        RequestStore.store[:current_request] ||= new(user)
      end

      def current
        RequestStore.store[:current_request]
      end
    end
  end
end
