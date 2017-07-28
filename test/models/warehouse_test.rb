require 'test_helper'

class WarehouseTest < ActiveSupport::TestCase
  def setup
    @warehouse = warehouses :warehouse_1
  end

  def teardown
    @warehouse = nil
  end

  test "has many locations" do
    assert_not_empty @warehouse.locations
  end

  test "create" do
    warehouse = Warehouse.new(
      address_1: "ABC Street",
      address_2: "5b",
      suburb: "Asdf",
      postal_code: "1234",
      state: "act"
    )

    assert_save warehouse
  end

  test "state defaults to ACT" do
    warehouse = Warehouse.new(
      address_1: "ABC Street",
      address_2: "5b",
      suburb: "Asdf",
      postal_code: "1234",
      state: "act"
    )

    assert_save warehouse
    assert warehouse.act?
  end

  test "destroy" do
    warehouse = warehouses :empty

    assert warehouse.can_destroy?
    assert_difference "Warehouse.count", -1 do
      warehouse.destroy
    end
  end

  test "cannot destroy if location exists" do
    assert_not @warehouse.can_destroy?
    assert_no_difference "Warehouse.count" do
      @warehouse.destroy
    end

    assert_has_error @warehouse, :base
  end

  test "cannot save without address_1" do
    warehouse = Warehouse.new

    assert_not warehouse.save
    assert_has_error warehouse, :address_1
  end

  test "cannot save without suburb" do
    warehouse = Warehouse.new

    assert_not warehouse.save
    assert_has_error warehouse, :suburb
  end

  test "cannot save without postal_code" do
    warehouse = Warehouse.new

    assert_not warehouse.save
    assert_has_error warehouse, :postal_code
  end

  test "capacity must be >= 0" do
    warehouse = Warehouse.new capacity: -1

    assert_not warehouse.save
    assert_has_error warehouse, :capacity
  end

  test "cannot save if capacity not integer" do
    warehouse = Warehouse.new capacity: 1.1

    assert_not warehouse.save
    assert_has_error warehouse, :capacity
  end
end
