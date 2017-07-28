require 'test_helper'

class BookingItemStockTest < ActiveSupport::TestCase
  def setup
    @booking_item_stock = booking_item_stocks :booking_1_item_stock_1
  end

  def teardown
    @booking_item_stock = nil
  end

  test "belongs to booking" do
    assert_not_nil @booking_item_stock.booking
  end

  test "belongs to item_stock" do
    assert_not_nil @booking_item_stock.item_stock
  end

  test "create" do
    booking = bookings :booking_1
    item = items :item_1
    item_stock = item.item_stocks.new

    booking_item_stock = BookingItemStock.new item_stock: item_stock, booking: booking

    assert_save booking_item_stock
  end

  test "cannot create if item_stock not unique" do
    booking = bookings :booking_1

    booking_item_stock = BookingItemStock.new(
      booking: booking,
      item_stock: @booking_item_stock.item_stock
    )

    assert_not booking_item_stock.save
    assert_has_error booking_item_stock, :item_stock
  end

  test "cannot create without booking" do
    booking_item_stock = BookingItemStock.new

    assert_not booking_item_stock.save
    assert_has_error booking_item_stock, :booking
  end

  test "cannot create without item_stock" do
    booking_item_stock = BookingItemStock.new

    assert_not booking_item_stock.save
    assert_has_error booking_item_stock, :item_stock
  end

  test "cannot create if booking.user is not equal to item.user" do
    user1 = users :user_1
    user2 = users :user_2

    booking = user2.bookings.first
    item_stock = user1.item_stocks.first
    booking_item_stock = BookingItemStock.new booking: booking, item_stock: item_stock

    assert_not booking_item_stock.save
    assert_has_error booking_item_stock, :base, "Cannot save item stock. Owner of item is different from the owner of booking"
  end
end
