class AddWeightToItemTable < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :weight, :float, default: 0
  end
end
