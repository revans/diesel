class UsersController < ApplicationController
  before_action :find_user

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(profile_params)
        format.html { redirect_to @user, notice: 'The profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  private

  def find_user
    @user = @current_user
  end

  def profile_params
    params.require(:user).permit(
      :name, :email, :password, :password_confirmation
    )
  end
end
