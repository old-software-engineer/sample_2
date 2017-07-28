class AddSkuToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :sku, :string, default: ""
  end
end
