require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  setup do
    @user = users(:bob)
    login_as(@user)
  end

  def test_index
    get :index
    assert_response :success
    assert_template :index
  end
end
