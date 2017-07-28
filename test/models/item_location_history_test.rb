require 'test_helper'

class ItemLocationHistoryTest < ActiveSupport::TestCase
  def setup
    @item_location_history = item_location_histories :item_location_history_1
  end

  def teardown
    @item_location_history = nil
  end

  test "belongs to location" do
    assert_not_nil @item_location_history.location
  end

  test "belongs to item" do
    assert_not_nil @item_location_history.item
  end

  test "create" do
    location = locations :location_1
    item = items :item_1
    i = ItemLocationHistory.new location: location, item: item

    assert_save i
  end

  test "cannot save without location" do
    i = ItemLocationHistory.new

    assert_not i.save
    assert_has_error i, :location
  end

  test "cannot save without item" do
    i = ItemLocationHistory.new

    assert_not i.save
    assert_has_error i, :item
  end

  test "should create item_location_history if item.location changed and it is not nil" do
    item = items :item_1
    item.location = locations :location_2

    assert_difference "ItemLocationHistory.count" do
      item.save
    end
  end

  test "should not create item_location_history if item.location is nil" do
    item = items :item_1
    item.location = nil

    assert_no_difference "ItemLocationHistory.count" do
      item.save
    end
  end

  # scope
  test "latest should order by created_at desc" do
    result = ItemLocationHistory.order(created_at: :desc)

    assert_equal result, result.latest
  end
end
