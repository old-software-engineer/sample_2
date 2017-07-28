class DropBoxTransactions < ActiveRecord::Migration[5.0]
  def change
    drop_table :box_transactions
  end
end
