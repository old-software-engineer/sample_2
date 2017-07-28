require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users :user_1
    sign_in @user
  end

  def teardown
    @user = nil
  end

  test "should get get_started" do
    get welcome_get_started_url
    assert_response :success
  end
end
