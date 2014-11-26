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

end