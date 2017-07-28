require 'test_helper'

class IdentityTest < ActiveSupport::TestCase
  def setup
    @user = users :user_1
    @identity = identities :identity_1
    @auth = OmniAuth::AuthHash.new uid: @identity.uid, provider: @identity.provider, info: { email: @user.email }
    @new_auth = OmniAuth::AuthHash.new uid: 1, provider: "some_provider", info: { email: @user.email }
  end

  def teardown
    @user = nil
    @identity = nil
    @auth = nil
    @new_auth = nil
  end

  def new_user_auth
    OmniAuth::AuthHash.new uid: 1, provider: "some_provider", info: { email: "user_does_not_exist@email.com" }
  end

  test "user can have many identities" do
    assert_equal 2, @user.identities.count
  end

  test "from omniauth should return an user" do
    user = Identity.from_oauth @auth

    assert_equal @identity.user, user
  end

  test "should not create identify if identity exists" do
    assert_no_difference "Identity.count" do
      Identity.from_oauth @auth
    end
  end

  test "should not create user if identity exists" do
    assert_no_difference "User.count" do
      Identity.from_oauth @auth
    end
  end

  test "should create identity if identity does not exist" do
    assert_difference "Identity.count" do
      Identity.from_oauth @new_auth
    end
  end

  test "should create user if identiy and user does not exist" do
    assert_difference "User.count" do
      Identity.from_oauth new_user_auth
    end
  end

  test "should not create user if identity does not exist and user does" do
    assert_no_difference "User.count" do
      Identity.from_oauth @new_auth
    end
  end

  test "should set password and email for new user" do
    user = Identity.from_oauth new_user_auth

    assert_not_nil user.email
    assert_not_nil user.password
  end

  test "should skip confirmation if not confirmed" do
    user = Identity.from_oauth new_user_auth

    assert_not_nil user.confirmed_at
  end

  test "should not save without a user" do
    identity = Identity.new

    assert_not identity.save
    assert_not_empty identity.errors.messages[:user]
  end

  test "should not save without a provider" do
    identity = Identity.new

    assert_not identity.save
    assert_not_empty identity.errors.messages[:provider]
  end

  test "should not save without an uid" do
    identity = Identity.new

    assert_not identity.save
    assert_not_empty identity.errors.messages[:uid]
  end
end
