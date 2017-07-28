class CreateBoxTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :box_transactions do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.references :booking, null: false, index: true, foreign_key: true
      t.integer :balance, default: 0, null: false
      t.integer :num_delivered, default: 0, null: false
      t.integer :num_picked_up, default: 0, null: false

      t.timestamps
    end
  end
end
