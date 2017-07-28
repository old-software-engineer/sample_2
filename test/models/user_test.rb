require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users :user_1
  end

  def teardown
    @user = nil
  end

  test "has many items" do
    assert_not_empty @user.items
  end

  test "has many item_stocks through items" do
    assert_not_empty @user.item_stocks
  end

  test "has many bookings" do
    assert_not_empty @user.bookings
  end

  test "has many booking_items through bookings" do
    assert_not_empty @user.booking_items
  end

  test "has many contacts" do
    assert_not_empty @user.contacts
  end

  test "has many invoices" do
    assert_not_empty @user.invoices
  end

  test "return first contact" do
    assert_not_nil @user.contact
  end

  # create
  test "active defaults to true" do
    user = User.create email: "email@email.com", password: "password"

    assert user.save
    assert user.active
  end

  # scope
  test "order by email" do
    results = User.order_by_email
    first_user = users :user_1
    last_user = users :user_2

    assert_equal first_user, results.first
    assert_equal last_user, results.last
  end
end
