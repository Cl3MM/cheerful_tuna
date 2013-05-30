class AddContactToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :member_id, :integer
    add_column :invoices, :contact_id, :integer
    add_column :invoices, :invoicee_infos, :string
    add_column :invoices, :invoicee, :string
  end
end
