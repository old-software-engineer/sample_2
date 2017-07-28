class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.float :space_usage, default: 0, precision: 6, scale: 1
      t.integer :num_boxes, default: 0
      t.integer :num_items, default: 0
      t.timestamp :invoice_date
      t.boolean :paid, default: false
      t.string :pdf_url

      t.timestamps
    end
  end
end
