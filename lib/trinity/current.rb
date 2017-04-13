module Trinity
  #Encapsulate current request data
  class Current
    attr_accessor :team, :user

    def initialize(user)
      @user = user
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
