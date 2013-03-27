class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string  :code
      t.string  :country

      t.timestamps
    end
    add_index :invoices, :code, unique: true
  end
end
