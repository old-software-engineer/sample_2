require 'test_helper'

class BookingTest < ActiveSupport::TestCase
  def setup
    @user = users :user_1
    @booking = bookings :booking_1
  end

  def teardown
    @user = nil
    @booking = nil
  end

  test "belongs to user" do
    assert_not_nil @booking.user
  end

  test "has many booking_items" do
    assert_not_empty @booking.booking_items
  end

  test "has many items through booking_items" do
    assert_not_empty @booking.items
  end

  test "has many booking_item_stocks" do
    assert_not_empty @booking.booking_item_stocks
  end

  test "has many item_stocks through booking_item_stocks" do
    assert_not_empty @booking.item_stocks
  end

  # create
  test "create" do
    booking = @user.bookings.new(
      address: "ABC Street",
      contact_name: "Bob Dylan",
      contact_phone: "0123456789"
    )

    assert_save booking
  end

  test "status defaults to pending" do
    booking = @user.bookings.new(
      address: "ABC Street",
      contact_name: "Bob Dylan",
      contact_phone: "0123456789"
    )

    assert_save booking
    assert booking.pending?
  end

  test "create booking with items" do
    items = @user.items.in_storage

    booking = @user.bookings.new(
      address: "ABC Street",
      contact_name: "Bob Dylan",
      contact_phone: "0123456789",
      items: items
    )

    assert_save booking
    assert_not_empty booking.items
  end

  test "should not create item delivery if not item owner" do
    user = users :user_2

    booking = user.bookings.new(
      address: "ABC Street",
      contact_name: "Bob Dylan",
      contact_phone: "0123456789",
      items: @user.items
    )

    assert_not booking.save
    assert_has_error booking, :"booking_items.base"
  end

  test "should not create booking without a user" do
    booking = Booking.new

    assert_not booking.save
    assert_has_error booking, :user
  end

  test "contact info cannot be blank" do
    booking = Booking.new

    assert_not booking.save
    assert_has_error booking, :contact_name
    assert_has_error booking, :contact_phone
    assert_has_error booking, :address
  end

  # update
  test "update status to processed" do
    booking = bookings :pending
    assert booking.processed!
  end

  test "mark as read" do
    assert_not @booking.read
    assert @booking.mark_as_read
    assert @booking.read
  end

  test "can cancel if not new record and not canceled" do
    booking = bookings :can_cancel

    assert booking.pending?
    assert booking.can_cancel?
    assert booking.cancel
    assert booking.canceled?
  end

  # query
  test "can_batch_create_item_stocks returns true if item stocks is empty" do
    booking = bookings :can_batch_create

    assert_empty booking.item_stocks
    assert booking.can_batch_create_item_stocks?
  end

  test "can_batch_create_item_stocks returns false if item stocks is not empty" do
    assert_not_empty @booking.item_stocks
    assert_not @booking.can_batch_create_item_stocks?
  end

  test "find_or_build_item_stocks builds item_stocks if item_stocks is empty" do
    booking = Booking.new items: Item.all
    booking.find_or_build_item_stocks

    assert_not_empty booking.item_stocks
    assert booking.item_stocks.first.new_record?
  end

  test "find_or_build_item_stocks returns item_stocks if item_stocks is not empty" do
    @booking.find_or_build_item_stocks

    assert_not_empty @booking.item_stocks
    assert_not @booking.item_stocks.first.new_record?
  end

  # scope
  test "latest should be ordered by id desc" do
    latest = @user.bookings.latest

    assert_equal @user.bookings.order(id: :desc), latest
  end
end
