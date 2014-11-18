require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:bob)
    login_as(@user)
  end

  test "edit page" do
    get :edit, id: @user.id
    assert_response :success
    assert_not_nil assigns(:user)
    assert_template :edit
  end

  test "updating profile" do
    patch :update, id: @user.id, user: {
      name: 'Bob Smith'
    }

    assert_redirected_to edit_user_url(assigns(:user))
    assert_equal 'Bob Smith', assigns(:user).name
  end

  test "updating profile via json" do
    patch :update, id: @user.id, user: {
      name: 'Bob Smith'
    }, format: :json

    assert_response :success
    assert_template :show
    assert_equal 'Bob Smith', assigns(:user).name
  end
end
