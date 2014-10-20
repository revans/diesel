module Api
  module V1
    class PingController < ApiController
      skip_before_action :authenticate

      def index
        render json: 'pong'.to_json, status: 200
      end

    end
  end
end
