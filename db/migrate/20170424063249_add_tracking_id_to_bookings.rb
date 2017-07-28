class AddTrackingIdToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :tracking_id, :string, default: ""
  end
end
