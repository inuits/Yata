require File.dirname(__FILE__) + '/../test_helper'

class AuthuserTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :authusers

  def test_should_create_authuser
    assert_difference 'Authuser.count' do
      authuser = create_authuser
      assert !authuser.new_record?, "#{authuser.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference 'Authuser.count' do
      u = create_authuser(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'Authuser.count' do
      u = create_authuser(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'Authuser.count' do
      u = create_authuser(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference 'Authuser.count' do
      u = create_authuser(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    authusers(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal authusers(:quentin), Authuser.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    authusers(:quentin).update_attributes(:login => 'quentin2')
    assert_equal authusers(:quentin), Authuser.authenticate('quentin2', 'test')
  end

  def test_should_authenticate_authuser
    assert_equal authusers(:quentin), Authuser.authenticate('quentin', 'test')
  end

  def test_should_set_remember_token
    authusers(:quentin).remember_me
    assert_not_nil authusers(:quentin).remember_token
    assert_not_nil authusers(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    authusers(:quentin).remember_me
    assert_not_nil authusers(:quentin).remember_token
    authusers(:quentin).forget_me
    assert_nil authusers(:quentin).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    authusers(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil authusers(:quentin).remember_token
    assert_not_nil authusers(:quentin).remember_token_expires_at
    assert authusers(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    authusers(:quentin).remember_me_until time
    assert_not_nil authusers(:quentin).remember_token
    assert_not_nil authusers(:quentin).remember_token_expires_at
    assert_equal authusers(:quentin).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    authusers(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil authusers(:quentin).remember_token
    assert_not_nil authusers(:quentin).remember_token_expires_at
    assert authusers(:quentin).remember_token_expires_at.between?(before, after)
  end

protected
  def create_authuser(options = {})
    record = Authuser.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    record.save
    record
  end
end
