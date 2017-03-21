require 'trinity/decorator'

module Api
  module Bot
    class ChecksController < BotController
      include ::Trinity::Decorator

      def create
        uri = params[:uri]
        uri = "http://#{uri}" unless uri.start_with?('http')

        check = Check.create!(
          type: Check::TYPE_HTTP,
          name: params[:uri],
          uri: params[:uri],
          user: current.user,
          team: current.user.teams.first,
        )

        render json: check
      end

      def index
        checks = Check.where(user: current.user).limit(6).map do |c|
          {id: c.id.to_s, uri: c.uri}
        end
        render json: checks
      end

      def show
        check = Check.find(params[:id])
        check = decorate(check)

        render json: {
          uri: check.uri,
          mean_time: check.mean_time,
          current_status: check.current_status,
          uptime_1hour: check.uptime_1hour,
          uptime_1day: check.uptime_1day,
          chart_url: "http://chartd.co/a.png?w=580&h=180&d0=RXZZfhgdURRUYZgfccZXUM&d1=roksqfdcjfKGGMQOSXchUO&d2=y3vuuvljghrgcYZZcdVckg&ymin=45&ymax=90&s0=4991AE&s1=FF8300.&s2=FF5DAA-"
        }
      end
    end
  end
end
