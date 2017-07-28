class RemoveBoxFromItemTable < ActiveRecord::Migration[5.0]
  def change
    remove_column :items, :box
  end
end
