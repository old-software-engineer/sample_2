require 'test_helper'

class Bookings::PickUpControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users :user_1
    sign_in @user
  end

  def teardown
    @user = nil
  end

  test "should get new" do
    get pick_up_new_booking_url
    assert_response :success
  end

  test "should create pick up only" do
    items_params = @user.items.map { |i| { id: i.id, quantity: 1 } }

    assert_difference "Booking.count" do
      post(
        pick_up_bookings_url(format: :json),
        params: {
          booking: {
            address: "asdf",
            contact_name: "asdf",
            contact_phone: "123",
          },
          items: items_params
        }
      )
    end

    assert_response :success
  end

end
