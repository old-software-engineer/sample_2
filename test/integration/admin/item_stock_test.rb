require 'test_helper'

class Admin::ItemStockTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @admin = admin_users :admin_1
    sign_in @admin
  end

  def teardown
    @admin = nil
  end

  # item stocks
  test "get item_stocks" do
    get admin_item_stocks_url
    assert_response :success
  end

  test "show item_stock" do
    item_stock = ItemStock.first

    get admin_item_stock_url(item_stock)
    assert_response :success
  end

  test "edit item_stock" do
    item_stock = ItemStock.first

    get edit_admin_item_stock_url(item_stock)
    assert_response :success
  end

  test "update item_stock" do
    item_stock = ItemStock.latest.first

    patch admin_item_stock_url(item_stock), params: {
      item_stock: {
        quantity_diff: 0
      }
    }

    item_stock.reload

    assert_equal 0, item_stock.quantity_diff
    assert_redirected_to admin_item_stock_url(item_stock)
    assert_equal flash[:notice], "Item stock was successfully updated."
  end

  test "destroy item_stock" do
    item_stock = ItemStock.latest.first

    assert_difference "ItemStock.count", -1 do
      delete admin_item_stock_url(item_stock)
    end

    assert_redirected_to admin_item_stocks_url
    assert_equal flash[:notice], "Item stock was successfully destroyed."
  end

  # user / item stocks
  test "get item_stocks by user" do
    user = User.first

    get admin_user_user_item_stocks_url(user)
    assert_response :success
  end

  test "batch select booking" do
    user = users :user_2
    booking = user.bookings.first
    item_stocks = user.item_stocks.select { |item_stock| item_stock.booking_item_stock.nil? }
    item_stock_ids = item_stocks.map(&:id)
    booking_params = {
      booking: booking.id
    }.to_json

    assert (item_stocks.count > 0)
    assert_difference "BookingItemStock.count", item_stocks.count do
      post batch_action_admin_user_user_item_stocks_url(user), params: {
        batch_action: "select_booking",
        batch_action_inputs: booking_params,
        collection_selection: item_stock_ids
      }
    end

    item_stocks.each do |item_stock|
      item_stock.reload
      assert_not_nil item_stock.booking_item_stock
    end

    assert_redirected_to admin_user_user_item_stocks_url(user)
    assert_equal flash[:notice], "Booking: #{booking.id} Item Stocks: #{item_stock_ids.join(' ')}"
  end

  test "batch remove booking" do
    user = users :user_1
    item_stocks = user.item_stocks.select { |item_stock| !item_stock.booking_item_stock.nil? }
    item_stock_ids = item_stocks.map(&:id)

    assert (item_stocks.count > 0)
    post batch_action_admin_user_user_item_stocks_url(user), params: {
      batch_action: "remove_booking",
      collection_selection: item_stock_ids
    }

    item_stocks.each do |item_stock|
      item_stock.reload
      assert_nil item_stock.booking_item_stock
    end

    assert_redirected_to admin_user_user_item_stocks_url(user)
    assert_equal flash[:notice], "Booking deleted from Item Stocks: #{item_stock_ids.join(', ')}"
  end

  # item / item stocks
  test "get item_stocks by item" do
    item = Item.first

    get admin_item_item_item_stocks_url(item)
    assert_response :success
  end

  test "new item stock" do
    item = Item.first

    get new_admin_item_item_item_stock_url(item)
    assert_response :success
  end

  test "create item stock" do
    item = Item.first

    assert_difference "ItemStock.count" do
      post admin_item_item_item_stocks_url(item), params: {
        item_stock: {
          quantity_diff: 1
        }
      }
    end

    assert_redirected_to admin_item_item_item_stocks_url(item)
    assert_equal flash[:notice], "Item stock was successfully created."
  end
end
