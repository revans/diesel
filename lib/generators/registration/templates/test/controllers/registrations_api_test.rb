require 'test_helper'

class RegistrationsApiTest < ActionController::TestCase
  include ApiAuthTestHelper

  def setup
    @controller = RegistrationsController.new
    add_auth_token_to_header
  end

  def user_attributes
    {
      name:                   'Donald Cerrone',
      email:                  'cowboy@cerrone.com',
      password:               '123456',
      password_confirmation:  '123456',
    }
  end


  def test_registration
    post :create, format: :json, user: user_attributes

    assert_response :success
    assert_template :show
    assert_equal 'Donald Cerrone',      parse_body['name']
    assert_equal 'cowboy@cerrone.com',  parse_body['email']

    refute_nil parse_body['id']
    refute_nil parse_body['edit_url']
    refute_nil parse_body['profile_url']
  end

  def test_registration_failure
    post :create, format: :json, user: user_attributes.merge(password: '123')

    expected = {"password_confirmation"=>["doesn't match Password"]}
    assert_equal expected, parse_body
  end

end
