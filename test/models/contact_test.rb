require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  def setup
    @user = users :user_1
    @contact = contacts :contact_1
  end

  def teardown
    @user = nil
    @contact = nil
  end

  test "contact has one user" do
    assert_not_nil @contact.user
  end

  test "full name" do
    assert_equal @contact.full_name, "#{@contact.first_name} #{@contact.last_name}"
  end

  test "shuold create a contact" do
    contact = @user.contacts.new(
      address: "123 ABC Street",
      first_name: "First",
      last_name: "Last",
      phone: "1234567890"
    )

    assert contact.save
    assert_equal "123 ABC Street", contact.address
    assert_equal "First", contact.first_name
    assert_equal "Last", contact.last_name
    assert_equal "1234567890", contact.phone
  end

  test "shuold update a contact" do
    @contact.address = "321 CBA Street"
    @contact.phone = "0987654321"

    assert @contact.save
    assert_equal "321 CBA Street", @contact.address
    assert_equal "0987654321", @contact.phone
  end

  test "should not save without user" do
    contact = Contact.new

    assert_not contact.save
    assert_not_empty contact.errors.messages[:user]
  end

  test "should not save without a first name" do
    contact = Contact.new

    assert_not contact.save
    assert_not_empty contact.errors.messages[:first_name]
  end

  test "max length first name" do
    contact = Contact.new first_name: "a" * 51

    assert_not contact.save
    assert_not_empty contact.errors.messages[:first_name]
  end

  test "should not save without a last name" do
    contact = Contact.new

    assert_not contact.save
    assert_not_empty contact.errors.messages[:last_name]
  end

  test "max length last name" do
    contact = Contact.new last_name: "a" * 51

    assert_not contact.save
    assert_not_empty contact.errors.messages[:last_name]
  end

  test "should not save without an address" do
    contact = Contact.new

    assert_not contact.save
    assert_not_empty contact.errors.messages[:address]
  end

  test "max length address" do
    contact = Contact.new address: "a" * 201

    assert_not contact.save
    assert_not_empty contact.errors.messages[:address]
  end

  test "should not save without a phone" do
    contact = Contact.new

    assert_not contact.save
    assert_not_empty contact.errors.messages[:phone]
  end

  test "max length phone" do
    contact = Contact.new phone: "1" * 21

    assert_not contact.save
    assert_not_empty contact.errors.messages[:phone]
  end
end
