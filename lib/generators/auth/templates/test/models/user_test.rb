require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def user
    @user ||= User.create!(
      first_name:             'Test',
      last_name:              'Example',
      email:                  'test@example.com',
      password:               '123456',
      password_confirmation:  '123456'
    )
  end

  def test_creating_new_user
    assert_difference "User.count", 1 do
      user # creates the user

      # test attributes
      assert_equal 'Test',              user.first_name
      assert_equal 'Example',           user.last_name
      assert_equal 'test@example.com',  user.email
      assert user.password_digest
    end
  end


  def test_authentication_success
    bob = users(:bob)

    assert bob.authenticate("123456")
    assert user.authenticate("123456")
  end

  def test_authentication_failure
    bob = users(:bob)

    refute bob.authenticate("1234567")
    refute user.authenticate("1234569")
  end

end