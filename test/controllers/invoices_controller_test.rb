require 'test_helper'

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users :user_1
    sign_in @user
  end

  test "should get index" do
    get invoices_url
    assert_response :success
  end
end
