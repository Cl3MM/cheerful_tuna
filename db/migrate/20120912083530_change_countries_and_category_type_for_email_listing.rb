class ChangeCountriesAndCategoryTypeForEmailListing < ActiveRecord::Migration
  def up
    remove_index  :email_listings, :countries
    change_column :email_listings, :countries, :text
    change_column :email_listings, :categories, :text
  end

  def down
    change_column :email_listings, :countries, :string
    change_column :email_listings, :categories, :string
  end
end
