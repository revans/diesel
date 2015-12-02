
json.id             @user.id
json.name           @user.name
json.email          @user.email
json.profile_url    user_url(@user, format: :json)
json.edit_url       edit_user_url(@user, format: :json)
