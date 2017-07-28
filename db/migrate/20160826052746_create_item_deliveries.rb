class CreateItemDeliveries < ActiveRecord::Migration[5.0]
  def change
    create_table :item_deliveries do |t|
      t.references :item, null: false, index: true, foreign_key: true
      t.references :booking, null: false, index: true, foreign_key: true

      t.index [:item_id, :booking_id], unique: true
      t.timestamps

      t.timestamps
    end
  end
end
