require 'test_helper'

class BookingItemTest < ActiveSupport::TestCase
  def setup
    @booking_item = booking_items :booking_1_item_1
  end

  def teardown
    @booking_item = nil
  end

  def new_booking_item(attributes={})
    booking = bookings :booking_3
    item = items :item_2

    attributes[:booking] = booking
    attributes[:item] = item

    BookingItem.new attributes
  end

  test "belongs to booking" do
    assert_not_nil @booking_item.booking
  end

  test "belongs to item" do
    assert_not_nil @booking_item.item
  end

  test "delegate user to booking" do
    assert_not_nil @booking_item.user
  end

  test "create" do
    booking_item = new_booking_item quantity_ordered: 1

    assert_save booking_item
  end

  test "quantity ordered defaults to 0" do
    booking_item = new_booking_item

    assert_save booking_item
    assert_equal 0, booking_item.quantity_ordered
  end

  test "cannot create without a booking" do
    booking_item = BookingItem.new

    assert_not booking_item.save
    assert_has_error booking_item, :booking
  end

  test "cannot create without an item" do
    booking_item = BookingItem.new

    assert_not booking_item.save
    assert_has_error booking_item, :item
  end

  test "item with booking must be unique" do
    booking_item = BookingItem.new item: @booking_item.item, booking: @booking_item.booking

    assert_not booking_item.save
    assert_has_error booking_item, :item
  end

  test "cannot create if quantity ordered is negative" do
    booking_item = BookingItem.new quantity_ordered: -1

    assert_not booking_item.save
    assert_has_error booking_item, :quantity_ordered
  end

  test "cannot create if booking.user is not equal to item.user" do
    user1 = users :user_1
    user2 = users :user_2

    booking = user1.bookings.first
    item = user2.items.first

    booking_item = BookingItem.new booking: booking, item: item

    assert_not booking_item.save
    assert_has_error booking_item, :base
    assert_equal "Cannot book for item. Owner of item is different from the owner of booking", booking_item.errors.messages[:base].first
  end

  # scope
  test "latest should order by id desc" do
    expected = BookingItem.order(id: :desc)
    actual = BookingItem.latest

    assert_equal expected, actual
  end

  test "total_volume should equal sum of each quantity_ordered * item.volume" do
    expected = BookingItem.all.map do |booking_item|
      booking_item.item.volume * booking_item.quantity_ordered
    end.sum

    assert (expected > 0)
    assert_in_delta expected, BookingItem.total_volume, 10 ** (-5)
  end

  test "total_volume should be >= 0" do
    assert (BookingItem.none.total_volume >= 0)
  end
end
