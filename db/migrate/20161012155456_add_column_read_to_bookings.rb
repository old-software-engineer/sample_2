class AddColumnReadToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :read, :boolean, default: false
  end
end
