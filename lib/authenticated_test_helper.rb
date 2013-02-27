module AuthenticatedTestHelper
  # Sets the current authuser in the session from the authuser fixtures.
  def login_as(authuser)
    @request.session[:authuser_id] = authuser ? (authuser.is_a?(Authuser) ? authuser.id : authusers(authuser).id) : nil
  end

  def authorize_as(authuser)
    @request.env["HTTP_AUTHORIZATION"] = authuser ? ActionController::HttpAuthentication::Basic.encode_credentials(authusers(authuser).login, 'monkey') : nil
  end
  
end
