require 'test_helper'

class Admin::BookingItemTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @admin = admin_users :admin_1
    sign_in @admin
  end

  def teardown
    @admin = nil
  end

  # booking_item
  test "get booking_items" do
    get admin_booking_items_url
    assert_response :success
  end

  test "show booking item" do
    booking_item = BookingItem.first

    get admin_booking_item_url(booking_item)
    assert_response :success
  end

  test "edit booking item" do
    booking_item = BookingItem.first

    get edit_admin_booking_item_url(booking_item)
    assert_response :success
  end

  test "update booking_item" do
    booking_item = BookingItem.first

    patch admin_booking_item_url(booking_item), params: {
      booking_item: {
        quantity_ordered: 100
      }
    }

    booking_item.reload

    assert_equal 100, booking_item.quantity_ordered
    assert_redirected_to admin_booking_item_url(booking_item)
    assert_equal flash[:notice], 'Booking item was successfully updated.'
  end

  test "delete booking_item" do
    booking_item = BookingItem.latest.first

    assert_difference "BookingItem.count", -1 do
      delete admin_booking_item_url(booking_item)
    end

    assert_redirected_to admin_booking_items_url
    assert_equal flash[:notice], 'Booking item was successfully destroyed.'
  end

  # user / booking_items
  test "get booking_items by user" do
    user = users :user_1
    get admin_user_user_booking_items_url(user)
    assert_response :success
  end

  # item / booking_items
  test "get booking_items by item" do
    item = Item.first

    get admin_item_item_booking_items_url(item)
    assert_response :success
  end
end
