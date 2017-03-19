module Api
  module Bot
    class ChecksController < BotController

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
        checks = Check.where(user: current.user).map(&:uri)
        render json: checks
      end
    end
  end
end
