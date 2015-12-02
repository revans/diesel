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
      name: 'Joe'
    }

    assert_equal 'Joe', assigns(:user).name
    assert_redirected_to edit_user_url(assigns(:user))
  end

  def test_update_failure
    patch :update, id: @user.id, user: {
      password:               '123456',
      password_confirmation:  '123'
    }

    assert_response 200
    assert_equal "Password confirmation doesn't match Password", assigns(:user).errors.full_messages.first
  end

end
