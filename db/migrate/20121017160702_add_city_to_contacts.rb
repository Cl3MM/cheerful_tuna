class AddCityToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :city, :string
    add_column :contacts, :civility, :string
  end
end
