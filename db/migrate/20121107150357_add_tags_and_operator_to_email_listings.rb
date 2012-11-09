class AddTagsAndOperatorToEmailListings < ActiveRecord::Migration
  def change
    add_column :email_listings, :tags, :string
    add_column :email_listings, :operator, :string, default: "NONE"
  end
end
