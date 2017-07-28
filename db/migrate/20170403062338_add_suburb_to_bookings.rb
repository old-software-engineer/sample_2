class AddSuburbToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :suburb, :string, default: ""
  end
end
