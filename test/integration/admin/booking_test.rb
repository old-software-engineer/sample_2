require 'test_helper'

class Admin::BookingTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @admin = admin_users :admin_1
    sign_in @admin
  end

  def teardown
    @admin = nil
  end

  # booking
  test "get bookings" do
    get admin_bookings_url
    assert_response :success
  end

  test "show booking" do
    booking = bookings :booking_1

    get admin_booking_url(booking)
    assert_response :success
  end

  test "edit booking" do
    booking = bookings :booking_1

    get edit_admin_booking_url(booking)
    assert_response :success
  end

  test "update booking" do
    booking = Booking.pending.first
    booking_items_params = booking.booking_items.each_with_index.map do |booking_item, i|
      [i, { id: booking_item.id, item_id: booking_item.item.id, quantity_ordered: 10 }]
    end.to_h

    patch admin_booking_url(booking), params: {
      booking: {
        status: "processed",
        booking_items_attributes: booking_items_params
      }
    }

    booking.reload

    booking.booking_items.each do |booking_item|
      assert_equal 10, booking_item.quantity_ordered
    end
    assert_equal "processed", booking.status
    assert_redirected_to admin_booking_url(booking)
    assert_equal flash[:notice], 'Booking was successfully updated.'
  end

  test "new item stocks" do
    booking = bookings :booking_1

    get new_item_stocks_admin_booking_url(booking)
    assert_response :success
  end

  test "create item stocks" do
    booking = bookings :booking_1
    item_stocks_params = booking.booking_items.each_with_index.map do |booking_item, i|
      [i, { item_id: booking_item.item.id, adjustment_type: booking.booking_type, quantity_diff: 5 }]
    end.to_h

    assert_difference "ItemStock.count", 2 do
      patch create_item_stocks_admin_booking_url(booking), params: {
        booking: {
          item_stocks_attributes: item_stocks_params
        }
      }
    end
    assert_redirected_to admin_booking_url(booking)
    assert_equal flash[:notice], 'Updated item stocks'
  end

  # user booking
  test "get bookings by user" do
    user = users :user_1

    get admin_user_user_bookings_url(user)
    assert_response :success
  end

  test "new booking" do
    user = users :user_1

    get new_admin_user_user_booking_url(user)
    assert_response :success
  end

  test "create booking" do
    user = users :user_1

    assert_difference "Booking.count" do
      post(
        admin_user_user_bookings_url(user),
        params: {
          booking: {
            address: "asdf",
            contact_name: "asdf",
            contact_phone: "123"
          }
        }
      )
    end

    assert_redirected_to admin_user_user_bookings_url(user)
    assert_equal flash[:notice], 'Booking was successfully created.'
  end
end
