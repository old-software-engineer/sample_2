class RemoveDateStoredFromItemItemTable < ActiveRecord::Migration[5.0]
  def change
      remove_column :items, :date_stored_from
  end
end
