class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.string :address, null: false
      t.timestamp :booked_date
      t.integer :time_slot, default: 0
      t.float :pick_up_space, default: 0, precision: 5, scale: 1
      t.integer :num_empty_boxes, default: 0
      t.integer :booking_type, default: 0
      t.boolean :canceled, default: false
      t.integer :plan, default: 0 

      t.timestamps
    end
  end
end
