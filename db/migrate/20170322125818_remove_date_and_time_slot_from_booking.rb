class RemoveDateAndTimeSlotFromBooking < ActiveRecord::Migration[5.0]
  def change
    remove_column :bookings, :booked_date
    remove_column :bookings, :time_slot
  end
end
