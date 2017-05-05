module Trinity
  #Encapsulate current request data
  class Current
    attr_accessor :team, :user, :host, :domain

    def initialize(user, request, session)
      @session = session
      @user = user
      @host = request.host
      @domain = request.domain
      detect_team if @user.present?
    end

    def session
      @session
    end

    def signed_in?
      user.present?
    end

    def detect_team
      begin
        # TODO: Remove those magic string
        if @host && @host.start_with?('team-') && (@host.end_with?('noty.im') || @host.end_with?('noty.dev'))
          # TODO: Cache or do domain -> team mapping
          team = TeamService.find_team_from_host @host
          if TeamPolicy.can_manage?(team, user) || TeamPolicy.can_view?(team, user)
            session[:team] = team.id.to_s
            @team = team
            return
          else
            raise "Forbidden"
          end
        else
          @team = @user.teams.first if @user.present?
          if session[:team] && (team = Team.find(session[:team]))
            if TeamPolicy.can_manage?(team, user) || TeamPolicy.can_view?(team, user)
              @team = team
            else
              @team = session[:team] = nil
              raise "Fordbidden"
            end
          else
            @team = @user.default_team
            session[:team] = @user.default_team.id.to_s
          end
        end
      rescue => e
        session[:team] = nil
        raise "Fordbidden"
      end
    end


    class << self
      def instance(user, request, session)
        RequestStore.store[:current_request] ||= new(user, request, session)

        # Force recreare if current user is different form what we already had
        if user.id != current.user.id
          if (TeamPolicy.can_manage?(team, user) || TeamPolicy.can_view?(team, user))
            current.user = user
          else
            raise "Forbidden"
          end
        end

        current
      end

      def current
        RequestStore.store[:current_request]
      end

      def reset!
        RequestStore.store[:current_request] = nil
      end
    end
  end
end
