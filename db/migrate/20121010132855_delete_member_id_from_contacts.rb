class DeleteMemberIdFromContacts < ActiveRecord::Migration
  def up
    remove_column :contacts, :member_id
  end

  def down
    add_column :contacts, :member_id
  end
end
