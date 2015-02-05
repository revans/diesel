require 'test_helper'

class SessionsApiTest < ActionController::TestCase
  include ApiAuthTestHelper

  def setup
    @controller = SessionsController.new
    add_auth_token_to_header
  end

  def user
    @user ||= User.create(
      first_name:             'Donald',
      last_name:              'Cerrone',
      email:                  'cowboy@cerrone.com',
      password:               '123456',
      password_confirmation:  '123456',
    )
  end


  def test_login
    post :create, format: :json, user: {
      email:    user.email,
      password: '123456'
    }

    assert_response :success
    assert_equal 'Donald',              parse_body['first_name']
    assert_equal 'Cerrone',             parse_body['last_name']
    assert_equal 'cowboy@cerrone.com',  parse_body['email']

    refute_nil parse_body['id']
    refute_nil parse_body['edit_url']
    refute_nil parse_body['profile_url']
    refute_nil session[:user_id]
  end

  def test_failed_login
    post :create, format: :json, user: {
      email:    'cowboy@cerrone.com',
      password: '1234567'
    }

    assert_equal 'Failed login', parse_body['error']
    assert_nil session[:user_id]
  end

  def test_logout
    post :create, format: :json, user: {
      email:    user.email,
      password: '123456'
    }

    assert_response :success

    delete :destroy, format: :json, id: user.id
    assert_response :success
  end

end
