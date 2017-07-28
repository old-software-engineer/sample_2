require 'test_helper'

class Admin::LocationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @admin = admin_users :admin_1
    sign_in @admin
  end

  def teardown
    @admin = nil
  end

  # location
  test "get locations" do
    get admin_locations_url
    assert_response :success
  end

  test "show location" do
    location = Location.first

    get admin_location_url(location)
    assert_response :success
  end

  test "edit location" do
    location = Location.first

    get edit_admin_location_url(location)
    assert_response :success
  end

  test "update location" do
    location = Location.first

    patch admin_location_url(location), params: {
      location: {
        row: 999
      }
    }

    location.reload

    assert_equal 999, location.row.to_i
    assert_redirected_to admin_location_url(location)
    assert_equal flash[:notice], "Location was successfully updated."
  end

  test "destroy location" do
    location = locations :empty

    assert_difference "Location.count", -1 do
      delete admin_location_url(location)
    end

    assert_redirected_to admin_locations_url
    assert_equal "Location was successfully destroyed.", flash[:notice]
  end

  # warehouse / location
  test "get locations by warehouse" do
    warehouse = Warehouse.first

    get admin_warehouse_warehouse_locations_url(warehouse)
    assert_response :success
  end

  test "new location" do
    warehouse = Warehouse.first

    get new_admin_warehouse_warehouse_location_url(warehouse)
    assert_response :success
  end

  test "create location" do
    warehouse = Warehouse.first

    assert_difference "Location.count" do
      post admin_warehouse_warehouse_locations_url(warehouse), params: {
        location: {
          row: 999,
          height: 999,
          bay: 999
        }
      }
    end

    assert_redirected_to admin_warehouse_warehouse_locations_url(warehouse)
    assert_equal "Location was successfully created.", flash[:notice]
  end
end
