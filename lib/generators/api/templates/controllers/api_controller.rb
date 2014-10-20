module Api
  module V1
    class ApiController < ::ActionController::Base

      # For APIs, you may want to use
      # :null_session instead.
      #
      # protect_from_forgery with: :null_session
      skip_before_action :verify_authenticity_token

      # If using the responders gem for Rails 4.2
      # respond_to :json

      # This provides a simple token
      # authentication system
      #
      before_action :authenticate

      protected

      def authenticate
        authenticate_token || render_unauthorized
      end

      def authenticate_token
        params.store(:token, request.headers['HTTP_AUTHORIZATION']) unless params[:token].present?
        authorized?(params[:token])
      end

      def render_unauthorized
        self.headers['WWW-Authenticate'] = "Token realm=\"#{::Rails.configuration.x.company_name}\""
        render json: 'Bad credentials', status: 401
      end

      def authorized?(token)
        ::Rails.configuration.x.api_token == token
      end

    end
  end
end
