class AddParcelTypeToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :parcel_type, :string, default: ""
  end
end
