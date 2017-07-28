class AddColumnQuantityOrderedToBookingItem < ActiveRecord::Migration[5.0]
  def change
    add_column :booking_items, :quantity_ordered, :integer, default: 0

    BookingItem.find_each do |booking_item|
      booking_item.quantity_ordered = 1

      booking_item.save
    end
  end
end
