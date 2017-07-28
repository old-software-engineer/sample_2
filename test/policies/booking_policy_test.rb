require 'test_helper'

class BookingPolicyTest < ActiveSupport::TestCase
  def setup
    @user = users :user_1
    @booking = @user.bookings.first
  end

  def teardown
    @user = nil
    @booking = nil
  end

  test "scope" do
    assert_policy_scope @user.bookings, @user, Booking
  end

  test "show" do
    assert_policy @user, @booking, :show?
  end

  test "cannot show if not booking owner" do
    user = users :user_2
    assert_not_policy user, @booking, :show?
  end

  test "create" do
    booking = @user.bookings.new

    assert_policy @user, booking, :create?
  end

  test "cancel" do
    booking = bookings :can_cancel

    assert_policy @user, booking, :cancel?
  end

  test "cannot cancel if not booking owner" do
    user = users :user_2
    booking = bookings :can_cancel

    assert_not_policy user, booking, :cancel?
  end
end
