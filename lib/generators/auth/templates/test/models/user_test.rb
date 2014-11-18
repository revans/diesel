require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_creation
    assert_difference "User.count", 1 do
      User.create!(email:                 'test@example.com',
                   password:              '123456',
                   password_confirmation: '123456',
                   accept_terms:          true)
    end
  end

  def test_non_admin
    user = User.create!(
      email:                 'test@example.com',
      password:              '123456',
      password_confirmation: '123456',
      accept_terms:          true)

    refute user.is_admin?
  end

  def test_admin_assignment_and_unassignment
    user = User.create!(
      email:                 'test@example.com',
      password:              '123456',
      password_confirmation: '123456',
      accept_terms:          true,
    )

    refute user.is_admin?

    user.assign_as_admin!
    assert user.is_admin?

    user.unassign_as_admin!
    refute user.is_admin?
  end
end