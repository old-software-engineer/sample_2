class AddIndexForBookedDateToBookings < ActiveRecord::Migration[5.0]
  def change
    add_index :bookings, :booked_date
  end
end
