class AddMembersIdToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :member_id, :integer
    add_index :contacts, :member_id
    add_index :contacts, :company
    add_index :contacts, :country
  end
end
