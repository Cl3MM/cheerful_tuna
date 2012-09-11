class CreateEmailListings < ActiveRecord::Migration
  def change
    create_table :email_listings do |t|
      t.string :name, null: false
      t.string :countries
      t.string :categories
      t.integer :per_line, default: 70

      t.timestamps
    end
    add_index :email_listings, :countries, unique: true
    add_index :email_listings, :name, unique: true
  end
end
