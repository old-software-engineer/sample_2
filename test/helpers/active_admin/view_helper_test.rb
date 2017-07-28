require 'test_helper'

class ActiveAdmin::ViewHelper < ActionView::TestCase
  def setup
    @helper = @controller.helpers
  end

  test "booking status class defaults to nil" do
    booking = Booking.new

    assert_nil @helper.booking_status_class(booking)
  end

  test "booking status class returns :ok if booking is processed" do
    booking = Booking.new
    booking.status = :processed

    assert_equal :ok, @helper.booking_status_class(booking)
  end

  test "booking status class returns :error if booking is canceled" do
    booking = Booking.new
    booking.status = :canceled

    assert_equal :error, @helper.booking_status_class(booking)
  end

  test "print booking" do
    booking = Booking.new id: 1, booking_type: :pick_up, created_at: 1.day.from_now

    assert_equal "##{booking.id} - Pick up - #{@helper.format_date_month(booking.created_at)}", @helper.print_booking(booking)
  end

  test "print item" do
    item = Item.new id: 1, physical_id: 123

    assert_equal "##{item.id} - physical id #{item.physical_id}", @helper.print_item(item)
  end

  test "print location" do
    location = Location.new row: 1, bay: 1, height: 1

    assert_equal "R #{location.row} - B #{location.bay} - H #{location.height}", @helper.print_location(location)
  end
end
