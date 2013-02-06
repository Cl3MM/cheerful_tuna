class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      if Rails.env.test?
        t.integer :owner_id
        t.string  :owner_type,  limit:      80
      else
        t.integer :owner_id,    null:       false
        t.string  :owner_type,  null:       false,  limit: 30
      end
      t.string      :designation, limit: 50
      t.attachment  :nice_file
      t.string      :nice_file_fingerprint
    end
    add_index     :documents, [ :owner_id, :owner_type ]
    add_index     :documents, :designation
  end
end
