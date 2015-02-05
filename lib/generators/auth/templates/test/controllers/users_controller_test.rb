require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:bob)
    login_as(@user)
  end

  def test_edit_page
    get :edit, id: @user.id
    assert_response :success
    assert_not_nil assigns(:user)
    assert_template :edit
  end

  def test_updating_profile
    patch :update, id: @user.id, user: {
      first_name: 'Bob'
    }

    assert_redirected_to edit_user_url(assigns(:user))
    assert_equal 'Bob', assigns(:user).first_name
  end

  def test_updating_profile_via_json
    patch :update, id: @user.id, user: {
      last_name: 'Smith'
    }, format: :json

    assert_response :success
    assert_template :show
    assert_equal 'Smith', assigns(:user).last_name
  end


  def test_update_failure
    patch :update, id: @user.id, user: {
      password:               '123456',
      password_confirmation:  '123'
    }

    assert_response 200
    assert_equal "Password confirmation doesn't match Password", assigns(:user).errors.full_messages.first
  end

  def test_update_failure_via_json
    patch :update, id: @user.id, user: {
      password:               '123456',
      password_confirmation:  '123'
    }, format: :json

    assert_response 422
    expects = {"password_confirmation"=>["doesn't match Password"]}
    assert_equal expects, JSON.parse(@response.body)
  end
end
