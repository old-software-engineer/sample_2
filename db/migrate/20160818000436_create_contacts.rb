class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.references :user,     null: false, index: true, foreign_key: true
      t.string     :address,  null: false
      t.string     :phone,    null: false, limit: 20
      t.string     :first_name,    null: false, limit: 50
      t.string     :last_name,    null: false, limit: 50


      t.timestamps
    end
  end
end
