class AddCityToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :city, :string, default: ""
  end
end
