class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.string  :designation
      t.integer :amount
      t.integer :invoice_id
      t.decimal :unit_price

      t.timestamps
    end
    add_index :line_items, :invoice_id
    add_column :invoices, :designation, :string
  end
end
