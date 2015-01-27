module ApiAuthentication
  extend ::ActiveSupport::Concern

  included do
    skip_before_action :require_authentication,     if: :json_requested?
    skip_before_action :verify_authenticity_token,  if: :json_requested?
    before_action :authenticate,                    if: :json_requested?
  end


  protected

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    params.store(:token, request.headers['HTTP_AUTHORIZATION']) unless params[:token].present?
    authorized?(params[:token])
  end

  def authorized?(token)
    Rails.application.config_for(:api)['token'] == token
  end

end
