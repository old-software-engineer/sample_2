class CreateItemStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :item_stocks do |t|
      t.references :item, null: false, index: true, foreign_key: { on_delete: :cascade }
      t.integer :quantity_diff, default: 0
      t.integer :quantity_in_storage, default: 0
      t.integer :adjustment_type, default: 0
      t.text :description, null: false, default: ""

      t.timestamps
    end
  end
end
