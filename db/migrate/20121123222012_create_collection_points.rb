class CreateCollectionPoints < ActiveRecord::Migration
  def change
    create_table :collection_points do |t|
      t.string :cp_id,          null: false, unique: true
      t.string :name,           null: false
      t.string :telephone,      null: false
      t.string :address,        null: false, unique: true
      t.string :postal_code,    null: false
      t.string :city,           null: false
      t.string :country,        null: false
      t.float  :longitude
      t.float  :latitude

      t.timestamps
    end
    add_index :collection_points, :name
  end
end
