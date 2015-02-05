require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
    assert_template :new
  end

  def test_registration
    post :create, user: {
      first_name:             'Bill',
      last_name:              'Example',
      email:                  'bill@example.com',
      password:               '123456',
      password_confirmation:  '123456',
    }

    assert_redirected_to login_url
    assert assigns(:user)
  end

  def test_failed_registration
    post :create, user: {
      first_name:             'Bill',
      last_name:              'Example',
      email:                  'bill@example.com',
      password:               '123456',
      password_confirmation:  '1234567',
    }

    assert_template :new
  end
end
