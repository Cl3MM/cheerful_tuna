class CreateCollectionPointsContactsTable < ActiveRecord::Migration
  def up
    create_table :collection_points_contacts, :id => false do |t|
        t.references :contact
        t.references :collection_point
    end
    add_index :collection_points_contacts, [ :contact_id, :collection_point_id ], name: "index_contact_id_collection_point_id"
  end

  def down
    drop_table :collection_points_contacts
  end
end
