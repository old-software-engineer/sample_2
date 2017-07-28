class AddStateToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :state, :string, default: ""
  end
end
