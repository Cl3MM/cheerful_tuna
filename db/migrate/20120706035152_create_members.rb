class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :company
      t.string :address
      t.string :city
      t.string :postal_code
      t.string :country
      t.string :activity
      t.string :category
      t.string :vat_number
      t.string :billing_address
      t.string :billing_city
      t.string :billing_postal_code
      t.string :billing_country

      t.timestamps
    end
    add_index :members, [:company, :country, :address], :unique => true
    add_index :members, :company
  end
end
