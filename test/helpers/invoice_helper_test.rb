require 'test_helper'

class InvoiceHelperTest < ActionView::TestCase
  def setup
    @helper = @controller.helpers
  end

  test "return today if prev_invoice date is today" do
    today = Time.zone.today.strftime("%d %b")
    invoice = Invoice.new invoice_date: Time.zone.today

    assert_equal today, @helper.format_prev_invoice_date_to_today(invoice)
  end

  test "return prev_date and today if prev_invoice date < today" do
    today = Time.zone.today.strftime("%d %b")
    prev_date = 1.month.ago.strftime("%d %b")
    invoice = Invoice.new invoice_date: 1.month.ago

    assert_equal "#{prev_date} - #{today}", @helper.format_prev_invoice_date_to_today(invoice)
  end
end
