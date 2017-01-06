module Trinity
  #Encapsulate current request data
  class Current
    attr_accessor :team, :user

    def initialize(user)
      @user = user
    end

    class << self
      def instance(user)
        @instance = new(user)
      end

      def current
        @instance
      end
    end
  end
end
