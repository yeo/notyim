module Trinity
  #Encapsulate current request data
  class Current
    attr_accessor :team, :user, :host, :domain

    def initialize(user, request)
      @user = user
      # TODO Revisit this when we rolledout team support
      @team = @user.teams.first if @user.present?
      @host = request.host
      @domain = request.domain
    end

    def signed_in?
      user.present?
    end

    class << self
      def instance(user, request)
        RequestStore.store[:current_request] ||= new(user, request)
      end

      def current
        RequestStore.store[:current_request]
      end
    end
  end
end
