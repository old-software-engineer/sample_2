class AddParcelDimensionToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :parcel_dimension, :string, default: ""
  end
end
