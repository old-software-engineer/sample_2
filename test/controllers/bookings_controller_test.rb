require 'test_helper'

class BookingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users :user_1
    sign_in @user

    @booking = @user.bookings.first
  end

  test "should get index" do
    get bookings_url
    assert_response :success
  end

  test "should show booking" do
    get booking_url(@booking)
    assert_response :success
  end

  test "should cancel booking" do
    patch cancel_booking_url(@booking)

    assert_redirected_to bookings_url
    assert_equal flash[:notice], 'Booking was successfully canceled.'
  end
end
