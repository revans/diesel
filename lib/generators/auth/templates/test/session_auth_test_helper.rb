
module SessionAuthTestHelper
  def login_as(user)
    @controller.send(:set_user_session, user)
  end

  def current_user
    @controller.current_user
  end

  def sessions
    @controller.session
  end
end
