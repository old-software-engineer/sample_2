require 'test_helper'

class Bookings::ItemDeliveryControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users :user_1
    sign_in @user

    @items = @user.items.in_storage
  end

  def teardown
    @user = nil
    @items = nil
  end

  test "should get new" do
    get item_delivery_new_booking_url(item_ids: @items.ids)
    assert_response :success
  end

  test "should create" do
    assert_difference "Booking.count" do
      post(
        item_delivery_bookings_url(format: :json),
        params: {
          booking: {
            address: "asdf",
            contact_name: "asdf",
            contact_phone: "123"
          },
          items: @items.map { |i| { id: i.id, quantity: 2 } }
        }
      )
    end

    assert_response :success
  end

  test "should not create if not item owner" do
    items = Item.in_storage

    assert_raises(ActiveRecord::RecordNotFound) do
      post(
        item_delivery_bookings_url(format: :json),
        params: {
          booking: {
            address: "asdf",
            contact_name: "asdf",
            contact_phone: "123"
          },
          items: items.map { |i| { id: i.id, quantity: 2 } }
        }
      )
    end
  end
end
