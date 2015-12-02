class RegistrationsController < ApplicationController
  skip_before_action :require_authentication

  def new
    @user = User.new
    respond_to :html, :json
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        set_user_session(@user)
        format.html { redirect_to login_url, notice: 'Your account has been created. You can now login.' }
        format.json { render template: 'users/show', status: :created, location: @user }
      else
        clean_user_session
        format.html { render :new, notice: 'Your account could NOT be created.' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email, :password, :password_confirmation
    )
  end

end
