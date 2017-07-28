class ChangeColumnDefaultBoxInItem < ActiveRecord::Migration[5.0]
  def change
    change_column_default :items, :box, from: false, to: true
  end
end
