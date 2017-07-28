class AddSuburbToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :suburb, :string, default: ""
  end
end
