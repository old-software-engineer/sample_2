require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users :user_1
    sign_in @user
  end

  test "get show" do
    @contact = @user.contacts.first

    get account_url

    assert_response :success
    assert_equal @contact, @controller.current_user.contact
  end
end
