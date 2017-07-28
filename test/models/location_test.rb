require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  def setup
    @warehouse = warehouses :warehouse_1
    @location = locations :location_1
  end

  def teardown
    @warehouse = nil
    @location = nil
  end

  test "has one warehouse" do
    assert_not_nil @location.warehouse
  end

  test "has many items" do
    assert_not_empty @location.items
  end

  test "create" do
    location = @warehouse.locations.new row: 99, bay: 99, height: 99

    assert_save location
  end

  test "update" do
    @location.height = 99

    assert_save @location
  end

  test "destroy" do
      location = locations :empty

    assert location.can_destroy?
    assert_difference "Location.count", -1 do
      location.destroy
    end
  end

  test "cannot destroy if item exists at location" do
    assert_not_empty @location.items
    assert_not @location.can_destroy?
    assert_no_difference "Location.count" do
      @location.destroy
    end

    assert_has_error @location, :base
  end

  test "location must be unique" do
    location = @warehouse.locations.new row: 1, bay: 1, height: 1

    assert_not location.save
    assert_has_error location, :base
  end

  test "cannot save without warehouse" do
    location = Location.new

    assert_not location.save
    assert_has_error location, :warehouse
  end

  test "cannot save without row" do
    location = Location.new

    assert_not location.save
    assert_has_error location, :row
  end

  test "cannot save without bay" do
    location = Location.new

    assert_not location.save
    assert_has_error location, :bay
  end

  test "cannot save without height" do
    location = Location.new

    assert_not location.save
    assert_has_error location, :height
  end
end
