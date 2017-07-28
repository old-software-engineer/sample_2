class CreateItemLocationHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :item_location_histories do |t|
      t.references :location, foreign_key: true, null: false, index: true
      t.references :item, foreign_key: true, null: false, index: true

      t.timestamps
    end
  end
end
