class CreateBookingItemStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :booking_item_stocks do |t|
      t.references :booking, foreign_key: true, null: false, index: true
      t.integer :item_stock_id, null: false

      t.timestamps
    end
    
    add_foreign_key :booking_item_stocks, :item_stocks, column: :item_stock_id, unique: true, on_delete: :cascade
    add_index :booking_item_stocks, :item_stock_id, unique: true
  end
end
