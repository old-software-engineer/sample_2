require 'test_helper'

class Admin::InvoiceTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @admin = admin_users :admin_1
    sign_in @admin
  end

  def teardown
    @admin = nil
  end

  # invoices
  test "get invoices" do
    get admin_invoices_url
    assert_response :success
  end

  test "show invoice" do
    invoice = Invoice.first

    get admin_invoice_url(invoice)
    assert_response :success
  end

  test "edit invoice" do
    invoice = Invoice.first

    get edit_admin_invoice_url(invoice)
    assert_response :success
  end

  test "update invoice" do
    invoice = Invoice.first

    patch admin_invoice_url(invoice), params: {
      invoice: {
        paid: true
      }
    }

    invoice.reload

    assert invoice.paid
    assert_redirected_to admin_invoice_url(invoice)
    assert_equal flash[:notice], "Invoice was successfully updated."
  end

  # user / invoices
  test "get invoices by user" do
    user = User.first

    get admin_user_user_invoices_url(user)
    assert_response :success
  end

  test "new invoice" do
    user = User.first

    get new_admin_user_user_invoice_url(user)
    assert_response :success
  end

  test "create invoice" do
    user = User.first

    assert_difference "Invoice.count" do
      post admin_user_user_invoices_url(user), params: {
        invoice: {
          invoice_date: 1.day.ago,
          paid: false,
          pdf_url: 'a',
          space_usage: 10,
          num_items: 10
        }
      }
    end

    assert_redirected_to admin_user_user_invoices_url(user)
    assert_equal flash[:notice], "Invoice was successfully created."
  end
end
