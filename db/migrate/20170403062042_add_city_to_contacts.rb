class AddCityToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :city, :string, default: ""
  end
end
