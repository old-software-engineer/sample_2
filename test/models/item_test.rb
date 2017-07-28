require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  def setup
    @user = users :user_1
    @item = items :item_1
  end

  def teardown
    @user = nil
    @item = nil
  end

  # test "show full filepath of item image for debugging" do
  #   # more info
  #   # https://github.com/carrierwaveuploader/carrierwave/wiki/Using-CarrierWave-with-Minitest-and-Rails-5
  #
  #   Item.all.each do |item|
  #     puts "\n\n#{item.image.file.path}\n\n"
  #   end
  #   fail
  # end

  test "belongs to user" do
    assert_not_nil @item.user
  end

  test "belongs to location" do
    assert_not_nil @item.location
  end

  test "has one image" do
    assert_not_nil @item.image
  end

  test "has many item_location_histories" do
    assert_not_empty @item.item_location_histories
  end

  test "has many booking_items" do
    assert_not_empty @item.booking_items
  end

  test "has many bookings" do
    assert_not_empty @item.bookings
  end

  test "has many item_stocks" do
    assert_not_empty @item.item_stocks
  end

  # create
  test "create" do
    item = @user.items.new(
      title: "Books",
      sku: "123",
      image: @item.image # reuse image because I dont know how else to save an item with an image
    )

    assert_save item
  end

  test "physical id defaults to sku" do
    item = @user.items.new(
      title: "Books",
      sku: "123",
      image: @item.image # reuse image because I dont know how else to save an item with an image
    )

    assert_save item
    assert_equal item.sku, item.physical_id
  end

  test "sets volume on save" do
    item = @user.items.new(
      title: "Books",
      sku: "123",
      height: 1,
      width: 1,
      length: 1,
      image: @item.image # reuse image because I dont know how else to save an item with an image
    )

    volume = item.height * item.width * item.length

    assert_save item
    assert_equal volume, item.volume
  end

  test "cannot save without user" do
    item = Item.new

    assert_not item.save
    assert_has_error item, :user
  end

  test "cannot save without image" do
    item = Item.new

    assert_not item.save
    assert_has_error item, :image
  end

  test "cannot save without title" do
    item = Item.new

    assert_not item.save
    assert_has_error item, :title
  end

  test "cannot save without a sku" do
    item = Item.new

    assert_not item.save
    assert_has_error item, :sku
  end

  # update
  test "batch save location" do
    items = @user.items.in_storage
    location = locations :location_2

    Item.batch_save_location items, location

    items.each do |item|
      assert_equal location, item.location
      assert_not_empty item.item_location_histories
      assert_equal location, item.item_location_histories.latest.first.location
    end
  end

  test "batch remove location" do
    items = @user.items
    Item.batch_remove_location items

    items.each do |item|
      assert_nil item.location
    end
  end

  test "save item_location_history if location changes" do
    location = locations :location_2
    @item.location = location

    assert_save @item
    assert_equal location, @item.location
    assert_not_empty @item.item_location_histories
    assert_equal location, @item.item_location_histories.latest.first.location
  end

  test "save! item_location_history if location changes" do
    location = locations :location_2
    @item.location = location

    assert @item.save!
    assert_equal location, @item.location
    assert_not_empty @item.item_location_histories
    assert_equal location, @item.item_location_histories.latest.first.location
  end

  # query
  test "quantity in storage is 0 if item_stocks is empty" do
    item = items :empty_stock

    assert_empty item.item_stocks
    assert_equal 0, item.quantity_in_storage
  end

  test "quantity in storage" do
    assert @item.item_stocks.latest.first.quantity_in_storage, @item.quantity_in_storage
  end

  test "quantity_available is equal to quantity_in_storage - quantity_ordered_for_delivery" do
    quant_in_storage = @item.quantity_in_storage
    quant_ordered = @item.quantity_ordered_for_delivery

    assert(quant_ordered > 0)
    assert_equal (quant_in_storage - quant_ordered), @item.quantity_available
  end

  test "quantity_available decreases if quantity_ordered changes for a delivery" do
    booking = @item.bookings.pending.delivery.first
    booking_item = booking.booking_items.find_by item: @item

    assert_difference "@item.quantity_available", -1 do
      booking_item.increment! :quantity_ordered
    end
  end

  test "quantity_available increases if a delivery is canceled" do
    booking = @item.bookings.pending.delivery.first
    booking_item = booking.booking_items.find_by item: @item

    assert (booking_item.quantity_ordered > 0)
    assert_difference "@item.quantity_available", booking_item.quantity_ordered do
      booking.cancel
    end
  end

  test "quantity_available does not change if quantity_ordered changes for a pick_up" do
    booking = @item.bookings.pending.pick_up.first
    booking_item = booking.booking_items.find_by item: @item

    assert_no_difference "@item.quantity_available" do
      booking_item.increment! :quantity_ordered
    end
  end

  test "quantity_available does not change if a pick_up is canceled" do
    booking = @item.bookings.pending.pick_up.first

    assert_no_difference "@item.quantity_available" do
      booking.cancel
    end
  end

  test "quantity_available is >= 0" do
    assert(@item.quantity_available >= 0)
  end

  test "quantity_ordered_for_delivery" do
    quant_ordered = @item.bookings.pending.delivery.sum(:quantity_ordered)

    assert(quant_ordered > 0)
    assert_equal quant_ordered, @item.quantity_ordered_for_delivery
  end

  # scope
  test "latest should order by id desc" do
    assert_equal @user.items.order(id: :desc), @user.items.latest
  end

  test "in_storage shuold return items with quantity > 0" do
    expected = Item.all
      .select { |item| !item.item_stocks.empty? }
      .select { |item| item.quantity_in_storage > 0 }

    actual = Item.in_storage

    assert (actual.count > 0)
    assert_equal expected, actual
  end

  test "not_in_storage should return items with quantity = 0" do
    expected = Item.all
      .select { |item| !item.item_stocks.empty? }
      .select { |item| item.quantity_in_storage == 0 }

    actual = Item.not_in_storage

    assert (actual.count > 0)
    assert_equal expected, actual
  end

  test "with_latest_item_stock return items where item.item_stocks is not empty" do
    expected = Item.all.select { |item| !item.item_stocks.empty? }
    actual = Item.with_latest_item_stock

    assert_equal expected, actual
  end

  test "by_booking should return items associated with a booking" do
    booking = BookingItem.first.booking
    expected = booking.items
    actual = Item.by_booking booking

    assert_equal expected, actual
  end
end
