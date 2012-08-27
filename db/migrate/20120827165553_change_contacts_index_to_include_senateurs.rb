class ChangeContactsIndexToIncludeSenateurs < ActiveRecord::Migration
  def change
    indexes = ActiveRecord::Base.connection.indexes(:contacts).map{|i| i.name}
    remove_index :contacts, [:company, :country, :last_name] if indexes.include? 'index_contacts_on_company_and_country_and_last_name'
    add_index :contacts, [:company, :country, :first_name, :last_name, :address],
      :unique => true, :length => {country: 35, first_name: 30, last_name: 30, address: 200},
      name: "index_senateurs"
  end
end
