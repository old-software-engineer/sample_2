class RemovePlanFromBooking < ActiveRecord::Migration[5.0]
  def change
    remove_column :bookings, :plan
  end
end
