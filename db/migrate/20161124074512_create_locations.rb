class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.references :warehouse, foreign_key: true, null: false, index: true
      t.string :row, default: ""
      t.string :bay, default: ""
      t.string :height, default: ""

      t.timestamps
    end

    add_index :locations, [:warehouse_id, :row, :bay, :height], unique: true  
  end
end
