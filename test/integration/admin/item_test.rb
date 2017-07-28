require 'test_helper'

class Admin::ItemTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @admin = admin_users :admin_1
    sign_in @admin
  end

  def teardown
    @admin = nil
  end

  # items
  test "get items" do
    get admin_items_url
    assert_response :success
  end

  test "show item" do
    item = Item.first

    get admin_item_url(item)
    assert_response :success
  end

  test "edit item" do
    item = Item.first

    get edit_admin_item_url(item)
    assert_response :success
  end

  test "update item" do
    item = Item.first

    patch admin_item_url(item), params: {
      item: {
        sku: "a"
      }
    }

    item.reload

    assert_equal "a", item.sku
    assert_redirected_to admin_item_url(item)
    assert_equal flash[:notice], "Item was successfully updated."
  end

  test "batch action select location for items in admin/items" do
    location = Location.first

    items = Item.all
    item_ids = items.map(&:id)
    location_params = {
      location: location.id
    }.to_json

    post batch_action_admin_items_url, params: {
      batch_action: "select_location",
      batch_action_inputs: location_params,
      collection_selection: item_ids
    }

    items.each do |item|
      item.reload
      assert_equal location, item.location
    end

    assert_redirected_to admin_items_url
    assert_equal "Items: #{item_ids.join(', ')} @ R #{location.row} - B #{location.bay} - H #{location.height}", flash[:notice]
  end

  # bookign / items
  test "get items by booking" do
    booking = Booking.first

    get admin_booking_items_by_booking_items_url(booking)
    assert_response :success
  end

  test "batch action select location items in admin/bookings/:booking_id/items" do
    location = Location.first

    booking = Booking.first
    items = booking.items
    item_ids = items.map(&:id)
    location_params = {
      location: location.id
    }.to_json

    post batch_action_admin_booking_items_by_booking_items_url(booking), params: {
      batch_action: "select_location",
      batch_action_inputs: location_params,
      collection_selection: item_ids
    }

    assert_not_empty items
    items.each do |item|
      item.reload
      assert_equal location, item.location
    end

    assert_redirected_to admin_booking_items_by_booking_items_url(booking)
    assert_equal "Items: #{item_ids.join(', ')} @ R #{location.row} - B #{location.bay} - H #{location.height}", flash[:notice]
  end

  test "batch action remove location for items" do
    booking = Booking.first
    items = booking.items
    item_ids = items.map(&:id)

    post batch_action_admin_booking_items_by_booking_items_url(booking), params: {
      batch_action: "remove_location",
      collection_selection: item_ids
    }

    assert_not_empty items
    items.each do |item|
      item.reload
      assert_nil item.location
    end

    assert_redirected_to admin_booking_items_by_booking_items_url(booking)
    assert_equal "Locations removed from Items: #{item_ids.join(', ')}", flash[:notice]
  end

  # user / items
  test "get items by user" do
    user = User.first

    get admin_user_user_items_url(user)
    assert_response :success
  end

  test "new item" do
    user = User.first

    get new_admin_user_user_item_url(user)
    assert_response :success
  end

  test "create item" do
    # skip
  end

  test "batch action create_item_stocks" do
    user = users :user_1
    items = user.items
    item_ids = items.map(&:id)
    booking_params = {
      adjustment_type: "pick_up"
    }.to_json

    post batch_action_admin_user_user_items_url(user), params: {
      batch_action: "create_item_stocks",
      batch_action_inputs: booking_params,
      collection_selection: item_ids
    }

    params = {
      adjustment_type: "pick_up",
      item_ids: item_ids
    }

    assert_not_empty items
    assert_redirected_to new_item_stocks_admin_user_user_items_url(user, params)
  end

  test "new item_stocks" do
    user = users :user_1
    items = user.items
    item_ids = items.ids

    get new_item_stocks_admin_user_user_items_url(user), params: {
      item_ids: item_ids
    }
    assert_response :success
  end

  test "collection action create_item_stocks" do
    user = users :user_1
    items = user.items
    item_stocks_params = items.each_with_index.map do |item, i|
      [i, { item_id: item.id, quantity_diff: 10, adjustment_type: "pick_up" }]
    end.to_h

    assert_difference "ItemStock.count", items.count do
      post create_item_stocks_admin_user_user_items_url(user), params: {
        item_stocks: item_stocks_params
      }
    end

    assert_not_empty items
    assert_redirected_to admin_user_user_items_url(user)
    assert_equal "Created item stocks for items #{items.ids.join(', ')}", flash[:notice]
  end
end
