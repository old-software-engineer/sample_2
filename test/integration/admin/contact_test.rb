require 'test_helper'

class Admin::ContactTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @admin = admin_users :admin_1
    sign_in @admin
  end

  def teardown
    @admin = nil
  end

  # contacts
  test "get contacts" do
    get admin_contacts_url
    assert_response :success
  end

  test "show contact" do
    contact = Contact.first

    get admin_contact_url(contact)
    assert_response :success
  end

  test "edit contact" do
    contact = Contact.first

    get edit_admin_contact_url(contact)
    assert_response :success
  end

  test "update contact" do
    contact = Contact.first

    patch admin_contact_url(contact), params: {
      contact: {
        address: "asdf"
      }
    }

    contact.reload

    assert_equal "asdf", contact.address
    assert_redirected_to admin_contact_url(contact)
    assert_equal flash[:notice], "Contact was successfully updated."
  end

  # user / contacts
  test "get contacts by user" do
    user = User.first

    get admin_user_user_contacts_url(user)
    assert_response :success
  end

  test "new contact" do
    user = User.first

    get new_admin_user_user_contact_url(user)
    assert_response :success
  end

  test "create contact" do
    user = User.first

    assert_difference "Contact.count" do
      post admin_user_user_contacts_url(user), params: {
        contact: {
          address: "a",
          first_name: "a",
          last_name: "a",
          phone: 1
        }
      }
    end

    assert_redirected_to admin_user_user_contacts_url(user)
    assert_equal flash[:notice], "Contact was successfully created."
  end
end
