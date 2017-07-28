require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  def setup
    @user = users :user_1
    @invoice = invoices :invoice_1
  end

  def teardown
    @user = nil
    @invoice = nil
  end

  def new_invoice
    @user.invoices.new pdf_url: "some url"
  end

  test "belongs to user" do
    assert_not_nil @invoice.user
  end

  test "create" do
    invoice = new_invoice

    assert_save invoice
  end

  test "invoice space_usage is set to item_stocks.total_volume_in_storage on create" do
    invoice = new_invoice
    expected = @user.item_stocks.total_volume_in_storage
    actual = invoice.space_usage

    assert_save invoice
    assert_in_delta expected, actual, 10 ** (-5)
  end

  test "invoice num_items set to item_stocks.total_in_storage on create" do
    invoice = new_invoice
    expected = @user.item_stocks.total_in_storage
    actual = invoice.num_items

    assert_save invoice
    assert_equal expected, actual
  end

  test "invoice date defaults to today" do
    invoice = new_invoice

    assert_save invoice
    assert_equal Time.zone.today.to_date, invoice.invoice_date.to_date
  end

  test "cannot save without a user" do
    invoice = Invoice.new

    assert_not invoice.save
    assert_has_error invoice, :user
  end

  test "cannot save without a pdf url" do
    invoice = Invoice.new

    assert_not invoice.save
    assert_has_error invoice, :pdf_url
  end

  test "cannot save without a invoice date" do
    invoice = Invoice.new

    assert_not invoice.save
    assert_has_error invoice, :pdf_url
  end

  test "space usage must be greater than or equal to 0" do
    invoice = Invoice.new
    invoice.space_usage = -1

    assert_not invoice.save
    assert_has_error invoice, :space_usage
  end

  test "num items must be greater than or equal to 0" do
    invoice = Invoice.new
    invoice.num_items = -1

    assert_not invoice.save
    assert_has_error invoice, :num_items
  end

  test "readonly space_usage, num_boxes, num_items after create" do
    assert_no_difference "@invoice.space_usage" do
      @invoice.space_usage = 100
      @invoice.save
      @invoice.reload
    end

    assert_no_difference "@invoice.num_items" do
      @invoice.num_items = 100
      @invoice.save
      @invoice.reload
    end
  end

  test "latest should return invoice_date desc" do
    assert_equal @invoice, @user.invoices.latest.first
  end

  test "oldest should return invoice_date asc" do
    invoice = invoices :invoice_2

    assert_equal invoice, @user.invoices.oldest.first
  end

  test "monthly space usage" do
    monthly_usages = @user.invoices.monthly_space_usages

    assert_equal 10, monthly_usages[@invoice.invoice_date.strftime("%b %Y")]
    assert_equal 10, monthly_usages[@invoice.invoice_date.strftime("%b %Y")]
    assert_equal 0,  monthly_usages[3.months.ago.strftime("%b %Y")]
  end
end
