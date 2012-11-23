class CreateContactsCollectionTable < ActiveRecord::Migration
  def up
    create_table :contacts_collection_points, :id => false do |t|
        t.references :contact
        t.references :collection_point
    end
    add_index :contacts_collection_points, [:contact_id, :collection_point_id]
  end

  def down
    drop_table :contacts_collection_points
  end
end
