class AddStateToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :state, :string, default: ""
  end
end
