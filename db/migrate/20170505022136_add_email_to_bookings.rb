class AddEmailToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :email, :string, default: ""
  end
end
