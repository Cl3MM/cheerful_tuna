class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :address
      t.string :postal_code
      t.string :category
      t.string :country
      t.string :first_name
      t.string :last_name
      t.string :infos
      t.boolean :is_active, :default => true
      t.boolean :is_ceres_member, :default => false
      t.string :company
      t.string :position
      t.string :telphone
      t.string :fax
      t.string :cell

      t.timestamps
    end
  end
end
