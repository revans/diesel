
module SessionAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :current_user, :logged_in?

    attr_writer :current_user
  end

  def current_user
    @current_user ||= process_current_user
  end

  def logged_in?
    current_user.present? && session[:user_id] == current_user.id
  end

  private

  def require_authentication
    return true if logged_in?
    respond_to do |format|
      format.html { redirect_to login_url }
      format.json { render json: {errors: "You must login."}, status: :unprocessable_entity }
      format.js   { render text: "You must login to participate." }
    end
  end

  def set_user_session(user)
    session[:user_id] = user.id
    current_user      = user
  end

  def clean_user_session
    session[:user_id] = nil
    current_user      = nil
    reset_session
  end

  def process_current_user
    begin
      user = User.find(session[:user_id]) if session[:user_id]
      return user if user.present?

      clean_user_session

    rescue ActiveRecord::RecordNotFound
      clean_user_session

    end
  end

end
