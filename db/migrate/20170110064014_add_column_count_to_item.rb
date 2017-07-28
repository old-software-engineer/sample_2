class AddColumnCountToItem < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :count, :integer, default: 0

    Item.find_each do |item|
      if item.stored?
        item.count = 1
      end

      item.save!
    end
  end
end
