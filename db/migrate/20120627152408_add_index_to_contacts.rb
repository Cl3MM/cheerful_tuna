class AddIndexToContacts < ActiveRecord::Migration
  def change
    add_index :contacts, [:company, :country, :last_name, :address], :unique => true
  end
end
