require 'test_helper'

class Accounts::PasswordsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users :user_1
    sign_in @user
  end

  test "edit" do
    get edit_account_password_url

    assert_response :success
  end

  test "update" do
    patch(
      account_password_url,
      params: {
        user: {
          current_password: "password",
          password: "password",
          password_confirmation: "password"
        }
      }
    )

    assert_equal "Password was successfully updated. Please login with it", flash[:notice]
    assert_redirected_to new_user_session_url
  end

  test "fails to update password if incorrect current password" do
    patch account_password_url, params: { user: { current_password: "invalid" } }

    assert_equal "You must provide a valid current password", flash[:alert]
  end

  test "fails to update password if password confirmation does not match" do
    patch(
      account_password_path,
      params: {
        user: {
          current_password: "password",
          password: "new_password",
          password_confirmation: "not_matching"
        }
      }
    )

    assert_not @user.valid?
  end

  test "reset" do
    patch reset_account_password_path

    assert_redirected_to account_url
    assert_equal "We sent you an email with reset password instructions", flash[:notice]
  end
end
