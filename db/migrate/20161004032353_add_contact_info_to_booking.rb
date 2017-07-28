class AddContactInfoToBooking < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :contact_name, :string, default: "", limit: 50
    add_column :bookings, :contact_phone, :string, default: "", limit: 20 
  end
end
