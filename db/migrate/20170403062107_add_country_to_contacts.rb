class AddCountryToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :country, :string, default: ""
  end
end
