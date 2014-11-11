class SessionsController < ApplicationController
  skip_before_action :require_authentication, except: :destroy
  layout 'login'

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email])

    respond_to do |format|
      if @user.try(:authenticate, params[:user][:password])
        set_user_session(@user)
        format.html { redirect_to dashboard_url, notice: 'You are now logged in.' }
        format.json { render :show, status: :created, location: @user }
      else
        clean_user_session
        format.html { redirect_to login_url, notice: 'Could not log you in. Try again.' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    clean_user_session
    respond_to do |format|
      format.html { redirect_to login_url, notice: 'You have been logged out.' }
      format.json { head :no_content }
    end
  end
end
