class CreateContactsMembersTable < ActiveRecord::Migration
  def up
    create_table :contacts_members, :id => false do |t|
        t.references :contact
        t.references :member
    end
    add_index :contacts_members, [:contact_id, :member_id]
  end

  def down
    drop_table :contacts_members
  end
end
