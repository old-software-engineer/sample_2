require 'test_helper'

class Accounts::ContactsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users :user_1
    sign_in @user
  end

  test "new" do
    get new_account_contact_url

    assert_response :success
  end

  test "create contact" do
    assert_difference "Contact.count" do
      post(
        account_contact_url,
        params: {
          contact: {
            first_name: "First",
            last_name: "Last",
            address: "123 XYZ Street",
            phone: "1234567890"
          }
        }
      )
    end

    assert_redirected_to account_url
    assert_equal flash[:notice], "Contact was successfully saved."
  end

  test "edit contact" do
    get edit_account_contact_url

    assert_response :success
  end

  test "update contact" do
    patch account_contact_url, params: { contact: {} }

    assert_redirected_to account_url
    assert_equal flash[:notice], "Contact was successfully updated."
  end
end
