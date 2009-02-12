module AuthenticatedTestHelper
  # Sets the current authuser in the session from the authuser fixtures.
  def login_as(authuser)
    @request.session[:authuser_id] = authuser ? authusers(authuser).id : nil
  end

  def authorize_as(user)
    @request.env["HTTP_AUTHORIZATION"] = user ? ActionController::HttpAuthentication::Basic.encode_credentials(users(user).login, 'test') : nil
  end
end
