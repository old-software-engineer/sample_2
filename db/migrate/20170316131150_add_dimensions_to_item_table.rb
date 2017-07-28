class AddDimensionsToItemTable < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :height, :float, default: 0
    add_column :items, :width, :float, default: 0
    add_column :items, :length, :float, default: 0
  end
end
