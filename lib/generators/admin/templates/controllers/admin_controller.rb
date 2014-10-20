module Admin
  class AdminController < ::ApplicationController
    before_action :require_admin

    private

    def require_admin
      unless current_user.is_admin?
        flash[:error] = "This URL does not exist."
        redirect_to edit_user_url(current_user)
      end
    end

  end
end
