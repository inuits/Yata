require File.dirname(__FILE__) + '/../test_helper'
require 'authusers_controller'

# Re-raise errors caught by the controller.
class AuthusersController; def rescue_action(e) raise e end; end

class AuthusersControllerTest < ActionController::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :authusers

  def test_should_allow_signup
    assert_difference 'Authuser.count' do
      create_authuser
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'Authuser.count' do
      create_authuser(:login => nil)
      assert assigns(:authuser).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'Authuser.count' do
      create_authuser(:password => nil)
      assert assigns(:authuser).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'Authuser.count' do
      create_authuser(:password_confirmation => nil)
      assert assigns(:authuser).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'Authuser.count' do
      create_authuser(:email => nil)
      assert assigns(:authuser).errors.on(:email)
      assert_response :success
    end
  end
  

  

  protected
    def create_authuser(options = {})
      post :create, :authuser => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
    end
end
