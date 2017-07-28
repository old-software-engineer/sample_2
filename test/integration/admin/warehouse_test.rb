require 'test_helper'

class Admin::WarehouseTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @admin = admin_users :admin_1
    sign_in @admin
  end

  def teardown
    @admin = nil
  end

  test "get warehouses" do
    get admin_warehouses_url
    assert_response :success
  end

  test "show warehouse" do
    warehouse = Warehouse.first

    get admin_warehouse_url(warehouse)
    assert_response :success
  end

  test "new warehouse" do
    get new_admin_warehouse_url
    assert_response :success
  end

  test "create warehouse" do
    assert_difference "Warehouse.count" do
      post admin_warehouses_url, params: {
        warehouse: {
          address_1: "a",
          address_2: "a",
          suburb: "a",
          postal_code: "a",
          state: "wa",
          capacity: 1
        }
      }
    end

    warehouse = Warehouse.last
    assert_redirected_to admin_warehouse_url(warehouse)
    assert_equal "Warehouse was successfully created.", flash[:notice]
  end

  test "edit warehouse" do
    warehouse = Warehouse.first

    get edit_admin_warehouse_url(warehouse)
    assert_response :success
  end

  test "update warehouse" do
    warehouse = Warehouse.first

    patch admin_warehouse_url(warehouse), params: {
      warehouse: {
        address_1: "updated address",
      }
    }

    warehouse.reload

    assert_equal "updated address", warehouse.address_1
    assert_redirected_to admin_warehouse_url(warehouse)
    assert_equal "Warehouse was successfully updated.", flash[:notice]
  end

  test "destroy warehouse" do
    warehouse = warehouses :empty

    assert_difference "Warehouse.count", -1 do
      delete admin_warehouse_url(warehouse)
    end

    assert_redirected_to admin_warehouses_url
    assert_equal "Warehouse was successfully destroyed.", flash[:notice]
  end
end
