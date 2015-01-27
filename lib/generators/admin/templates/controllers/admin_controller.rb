module Admin
  class AdminController < ::ApplicationController
    before_action :require_admin
    # before_action :basic_authentication, unless: :bypass_auth?

    def logged_in?
      @logged_in
    end
    helper_method :logged_in?

    private

    def require_admin
      unless current_user.is_admin?
        flash[:error] = "This URL does not exist."
        redirect_to edit_user_url(current_user)
      end
    end


    def basic_authentication
      logged_in = authenticate_with_http_basic do |user, password|
        user == "" && password == ""
      end

      if logged_in
        @logged_in = logged_in
      else
        request_http_basic_authentication
      end
    end


    def bypass_auth?
      if Rails.env.development? || Rails.env.test?
        @logged_in = true
      else
        false
      end
    end

  end
end
