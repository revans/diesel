require 'test_helper'

class UsersApiTest < ActionController::TestCase
  include ApiAuthTestHelper

  def setup
    @controller = UsersController.new
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

  def test_updating_profile_via_json
    patch :update, id: user.id, user: {
      first_name: 'Bob'
    }, format: :json

    assert_response :success
    assert_template :show
    assert_equal 'Bob', assigns(:user).first_name
  end

  def test_update_failure_via_json
    patch :update, id: user.id, user: {
      password: '123456',
      password_confirmation: '123'
    }, format: :json

    assert_response 422
    expects = {"password_confirmation"=>["doesn't match Password"]}
    assert_equal expects, parse_body
  end
end
