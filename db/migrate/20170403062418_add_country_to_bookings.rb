class AddCountryToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :country, :string, default: ""
  end
end
