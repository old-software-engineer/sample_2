require 'test_helper'

class Admin::UserTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @admin = admin_users :admin_1
    sign_in @admin
  end

  def teardown
    @admin = nil
  end

  test "get users" do
    get admin_users_url
    assert_response :success
  end

  test "show user" do
    user = User.first

    get admin_user_url(user)
    assert_response :success
  end

  test "new user" do
    get new_admin_user_url
    assert_response :success
  end

  test "create user" do
    assert_difference "User.count" do
      post admin_users_url, params: {
        user: {
          email: 'new@email.com',
          password: 'abcdefg',
          password_confirmation: 'abcdefg'
        }
      }
    end

    user = User.find_by_email "new@email.com"

    assert user.confirmed?
    assert_redirected_to admin_user_url(user)
    assert "User was successfully created.", flash[:notice]
  end

  test "edit user" do
    user = User.first

    get edit_admin_user_url(user)
    assert_response :success
  end

  test "update user" do
    user = User.first

    patch admin_user_url(user), params: {
      user: {
        active: false
      }
    }

    assert user.confirmed?
    assert_redirected_to admin_user_url(user)
    assert_equal "User was successfully updated.", flash[:notice]
  end
end
