class CreateWarehouses < ActiveRecord::Migration[5.0]
  def change
    create_table :warehouses do |t|
      t.string :address_1, limit: 100,  default: ""
      t.string :address_2, limit: 100,  default: ""
      t.string :suburb, limit: 100,     default: ""
      t.string :postal_code, limit: 100, default: ""
      t.integer :state,                 default: 0
      t.integer :capacity, default: 0

      t.timestamps
    end
  end
end
