module Trinity
  #Encapsulate current request data
  class Current
    attr_accessor :team, :user, :host, :domain

    def initialize(user, request)
      @user = user
      team_pick if @user.present?
      @host = request.host
      @domain = request.domain
    end

    def signed_in?
      user.present?
    end

    def team_pick
      byebug
      begin
        # TODO: Remove those magic string
        if @host.start_with?('team-') && (@host.end_with?('noty.im') || @host.end_with?('noty.dev'))
          # TODO: Cache or do domain -> team mapping
          team = TeamService.find_team_from_host @host
          if TeamPolicy.can_manage?(team, current.user) || TeamPolicy.can_view?(team, current.user)
            session[:team] = team.id.to_s
            @team = team
            return
          else
            return head(:forbidden)
          end
        else
          @team = @user.teams.first if @user.present?
          if session[:team] && (team = Team.find(session[:team]))
            if TeamPolicy.can_manage?(team, current.user) || TeamPolicy.can_view?(team, current.user)
              current.team = team
            else
              current.team = session[:team] = nil
              return head :forbidden
            end
          else
            current.team = current.user.default_team
            session[:team] = current.user.default_team.id.to_s
          end
        end
      rescue => e
        # This is terrible wrong, we need to log it
        # and look into its manually
        Bugsnag.notify e
        session[:team] = nil
        head :forbidden
      end
    end


    class << self
      def instance(user, request)
        RequestStore.store[:current_request] ||= new(user, request)

        # Force recreare if current user is different form what we already had
        if user.id != current.user.id
          byebug
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
