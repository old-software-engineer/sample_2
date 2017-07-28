class RemoveColumnCountFromItem < ActiveRecord::Migration[5.0]
  def change
    remove_column :items, :count
  end
end
