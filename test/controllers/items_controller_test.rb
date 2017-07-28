require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users :user_1
    sign_in @user

    @item = @user.items.first
  end

  def teardown
    @user = nil
    @item = nil
  end

  test "should get index" do
    get items_url
    assert_response :success
  end

  test "should get show" do
    get item_url(@item)
    assert_response :success
  end

  test "create" do
    file = Rack::Test::UploadedFile.new(File.open(Rails.root.join("test/files/test.png")))

    assert_difference "Item.count" do
      post(
        items_url,
        params: {
          item: {
            title: "a",
            sku: "a",
            description: "a",
            weight: 1,
            height: 2,
            length: 2,
            width: 2,
            image: file
          }
        }
      )
    end

    assert_redirected_to items_url
    assert_equal flash[:notice], "Item was successfully created."
  end

  test "edit" do
    get item_url(@item)

    assert_response :success
  end

  test "update" do
    patch(
      item_url(@item),
      params: {
        item: {
          title: "a",
          sku: "a",
          description: "a",
          image: @item.image
        }
      }
    )

    assert_redirected_to item_url(@item)
    assert_equal flash[:notice], "Item was successfully updated."
  end
end
