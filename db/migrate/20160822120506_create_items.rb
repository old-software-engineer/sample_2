class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.string :image, null: false, default: ""
      t.string :physical_id, :string, null: false, default: ""
      t.string :title, null: false, default: ""
      t.text :description, null: false, default: ""
      t.float :volume, default: 0, precision: 4, scale: 1
      t.timestamp :date_stored_from, null: false
      t.integer :status, default: 0
      t.boolean :box, default: false

      t.timestamps
    end
  end
end
