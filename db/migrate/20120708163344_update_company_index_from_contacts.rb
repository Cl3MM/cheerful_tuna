class UpdateCompanyIndexFromContacts < ActiveRecord::Migration
  def up
    remove_index :contacts, [:company, :country, :last_name, :address]
    add_index :contacts, [:company, :country, :last_name], :unique => true
  end

  def down
    remove_index :contacts, [:company, :country, :last_name]
    add_index :contacts, [:company, :country, :last_name, :address], :unique => true
  end
end
