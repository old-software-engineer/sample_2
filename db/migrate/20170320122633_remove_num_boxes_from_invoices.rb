class RemoveNumBoxesFromInvoices < ActiveRecord::Migration[5.0]
  def change
    remove_column :invoices, :num_boxes
  end
end
