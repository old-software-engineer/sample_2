class RemoveColumnCanceledFromBooking < ActiveRecord::Migration[5.0]
  def change
    remove_column :bookings, :canceled
  end
end
