require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  setup do
    @user = users(:bob)
  end

  def test_new
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
    assert_template :new

    refute @controller.current_user
    refute @controller.logged_in?
  end

  def test_login
    post :create, user: {
      email:    @user.email,
      password: 123456,
    }

    assert_redirected_to dashboard_url
    assert assigns(:user)

    assert @controller.current_user
    assert @controller.logged_in?
  end

  def test_failed_login
    post :create, user: {
      email:    @user.email,
      password: 12345,
    }

    assert_redirected_to login_url
    refute @controller.current_user
    refute @controller.logged_in?
  end

  def test_logout
    delete :destroy
    assert_redirected_to login_url
    refute @controller.current_user
    refute @controller.logged_in?
  end
end
