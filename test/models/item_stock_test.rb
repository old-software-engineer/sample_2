require 'test_helper'

class ItemStockTest < ActiveSupport::TestCase
  def setup
    @item = items :item_1
    @item_stock = @item.item_stocks.latest.first
    @la
  end

  def teardown
    @item = nil
    @item_stock = nil
  end

  def latest_item_stock
    @item.item_stocks.latest.first
  end

  def not_latest_item_stock
    @item.item_stocks.latest.second
  end

  test "belongs to item" do
    assert_not_nil @item_stock.item
  end

  test "has one optional booking_item_stock" do
    assert_not_nil @item_stock.booking_item_stock
  end

  test "has one optional booking through booking_item_stock" do
    assert_not_nil @item_stock.booking
  end

  test "create" do
    item_stock = @item.item_stocks.new(
      quantity_diff: 2,
      adjustment_type: :pick_up
    )
    quantity_in_storage = ItemStock.current_quantity_in_storage(@item) + item_stock.quantity_diff

    assert_save item_stock
    assert_equal quantity_in_storage, item_stock.quantity_in_storage
  end

  test "adjustment type defaults to pick_up" do
    item_stock = @item.item_stocks.new(
      quantity_diff: 2
    )

    assert_save item_stock
    assert item_stock.pick_up?
  end

  test "quantity_diff defaults to 0" do
    item_stock = @item.item_stocks.new

    assert_save item_stock
    assert_equal 0, item_stock.quantity_diff
  end

  test "can update description even if not the latest" do
    item_stock = not_latest_item_stock
    item_stock.description = "order id 1235"

    assert_not_equal @item_stock, item_stock
    assert_save item_stock
  end

  test "can update quantity_diff if latest for an item" do
    item_stock = latest_item_stock
    item_stock.adjustment_type = :pick_up
    item_stock.quantity_diff = 100

    quantity_in_storage = ItemStock.prev_quantity_in_storage(item_stock.item) + item_stock.quantity_diff

    assert item_stock.can_update_quantity?
    assert_save item_stock
    assert_equal quantity_in_storage, item_stock.quantity_in_storage
  end

  test "can update adjustment_type if latest for an item" do
    item_stock = latest_item_stock
    item_stock.adjustment_type = :delivery

    quantity_in_storage = ItemStock.prev_quantity_in_storage(item_stock.item) + item_stock.quantity_diff

    assert item_stock.can_update_quantity?
    assert_save item_stock
    assert_equal quantity_in_storage, item_stock.quantity_in_storage
  end

  test "cannot update guantity_diff if not latest for an item" do
    item_stock = not_latest_item_stock
    item_stock.quantity_diff = 100

    assert_not item_stock.can_update_quantity?
    assert_not item_stock.save
    assert_has_error item_stock, :base, "Not allowed to edit quantity unless latest"
  end

  test "cannot update adjustment_type if not latest for an item" do
    item_stock = not_latest_item_stock
    item_stock.adjustment_type = :delivery

    assert_not item_stock.can_update_quantity?
    assert_not item_stock.save
    assert_has_error item_stock, :base
  end

  test "can_update_quantity? is false if new" do
    item_stock = ItemStock.new

    assert_not item_stock.can_update_quantity?
  end

  test "can destroy if latest" do
    item_stock = latest_item_stock

    assert item_stock.can_destroy?
    assert item_stock.destroy
  end

  test "cannot destroy if not latest" do
    item_stock = not_latest_item_stock

    assert_not item_stock.can_destroy?
    assert_not item_stock.destroy
    assert_has_error item_stock, :base
  end

  test "can_destroy? is false if new" do
    item_stock = ItemStock.new

    assert_not item_stock.can_destroy?
  end

  test "destroy item_stock destroys booking_item_stock" do
    item_stock = latest_item_stock

    assert_not_nil item_stock.booking_item_stock
    assert item_stock.destroy
    assert item_stock.booking_item_stock.destroyed?
  end

  test "pick up increments quantity_in_storage" do
    quantity_diff = 2
    item_stock = @item.item_stocks.new(
      quantity_diff: quantity_diff,
      adjustment_type: :pick_up
    )
    quantity_in_storage = ItemStock.current_quantity_in_storage(@item) + quantity_diff

    assert_save item_stock
    assert_equal quantity_in_storage, item_stock.quantity_in_storage
  end

  test "delivery decrements quantity_in_storage" do
    quantity_diff = 2
    item_stock = @item.item_stocks.new(
      quantity_diff: quantity_diff,
      adjustment_type: :delivery
    )
    quantity_in_storage = ItemStock.current_quantity_in_storage(@item) - quantity_diff

    assert_save item_stock
    assert_equal quantity_in_storage, item_stock.quantity_in_storage
  end

  test "return increments quantity_in_storage" do
    quantity_diff = 2
    item_stock = @item.item_stocks.new(
      quantity_diff: quantity_diff,
      adjustment_type: :return
    )
    quantity_in_storage = ItemStock.current_quantity_in_storage(@item) + quantity_diff

    assert_save item_stock
    assert_equal quantity_in_storage, item_stock.quantity_in_storage
  end

  test "damaged decrements quantity_in_storage" do
    quantity_diff = 2
    item_stock = @item.item_stocks.new(
      quantity_diff: quantity_diff,
      adjustment_type: :damage
    )
    quantity_in_storage = ItemStock.current_quantity_in_storage(@item) - quantity_diff

    assert_save item_stock
    assert_equal quantity_in_storage, item_stock.quantity_in_storage
  end

  test "quantity_in_storage should equal current_quantity_in_storage + quantity_diff if new record" do
    quantity_diff = 2
    item_stock = @item.item_stocks.new(
      quantity_diff: quantity_diff,
      adjustment_type: :pick_up
    )
    quantity_in_storage = ItemStock.current_quantity_in_storage(@item) + quantity_diff

    assert_save item_stock
    assert_equal quantity_in_storage, item_stock.quantity_in_storage
  end

  test "quantity_in_storage is updated if quantity_diff or adjustment_type has changed" do
    item_stock = latest_item_stock

    item_stock.quantity_diff = 10
    item_stock.adjustment_type = :pick_up
    quantity_in_storage = ItemStock.prev_quantity_in_storage(item_stock.item) + item_stock.quantity_diff

    assert_save item_stock
    assert_equal quantity_in_storage, item_stock.quantity_in_storage
  end

  test "cannot save without item" do
    item_stock = ItemStock.new

    assert_not item_stock.save
    assert_has_error item_stock, :item
  end

  # class
  test "batch save booking from item_stocks" do
    user = users :user_1
    item_stocks = user.item_stocks
    booking = user.bookings.first

    ItemStock.batch_save_booking(booking, item_stocks)

    item_stocks.each do |item_stock|
      assert_equal booking, item_stock.booking
    end
  end

  test "bacth remove booking from item_stocks" do
    item_stocks = ItemStock.all

    assert_difference "BookingItemStock.count", - BookingItemStock.all.count do
      ItemStock.batch_remove_booking(item_stocks)
    end

    item_stocks.each do |item_stock|
      assert_nil item_stock.booking
    end
  end

  # scope
  test "latest should be order by id desc" do
    latest = @item.item_stocks.order(id: :desc).first

    assert_equal latest, latest_item_stock
  end

  test "previous quantity in storage" do
    item_stock = @item.item_stocks.latest.second

    assert_equal item_stock.quantity_in_storage, ItemStock.prev_quantity_in_storage(@item)
  end

  test "previous quantity in storage is 0 if item does not exist" do
    item = Item.new
    prev_quant = ItemStock.prev_quantity_in_storage item

    assert_equal 0, prev_quant
  end

  test "previous quantity in storage is 0 if previous item stock does not exist" do
    item = items :empty_stock
    prev_quant = ItemStock.prev_quantity_in_storage item

    assert_empty item.item_stocks
    assert_equal 0, prev_quant
  end

  test "current quantity in storage" do
    item_stock = latest_item_stock

    assert_equal item_stock.quantity_in_storage, ItemStock.current_quantity_in_storage(item_stock.item)
  end

  test "current quantity in storage is 0 if item does not exist" do
    item = Item.new
    current_quant = ItemStock.current_quantity_in_storage item

    assert_equal 0, current_quant
  end

  test "current quantity in storage is 0 if item stock does not exist" do
    item = items :empty_stock
    current_quant = ItemStock.current_quantity_in_storage item

    assert_empty item.item_stocks
    assert_equal 0, current_quant
  end

  test "latest_group_by_item returns the latest item stock ids for each item" do
    expected = ItemStock.all.map do |item_stock|
      item = item_stock.item
      [item.id, item.item_stocks.latest.first.id]
    end.to_h

    assert_not_empty expected
    assert_equal expected, ItemStock.latest_group_by_item
  end

  test "in_storage returns the latest item_stock where quantity_in_storage > 0" do
    latest_item_stock_ids = ItemStock.latest_group_by_item.values
    expected = ItemStock.where(id: latest_item_stock_ids).where("quantity_in_storage > 0")

    assert_equal expected.ids, ItemStock.in_storage.ids
  end

  test "total_volume_in_storage should sum the latest item stocks by item.volume * item_stock.quantity_in_storage" do
    expected = Item.all.sum do |item|
      item.volume * item.quantity_in_storage
    end

    assert (expected > 0)
    assert_in_delta expected, ItemStock.total_volume_in_storage, 10 ** (-5)
  end

  test "total_in_storage should sum the latest item_stocks by quantity_in_storage" do
    expected = ItemStock.in_storage.sum(:quantity_in_storage)

    assert (expected > 0)
    assert_equal expected, ItemStock.total_in_storage
  end
end
