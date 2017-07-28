class RenameTableItemDeliveryToBookingItem < ActiveRecord::Migration[5.0]
  def change
    rename_table :item_deliveries, :booking_items
  end
end
