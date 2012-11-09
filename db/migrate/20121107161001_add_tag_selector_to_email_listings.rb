class AddTagSelectorToEmailListings < ActiveRecord::Migration
  def change
    add_column :email_listings, :tag_selector, :string, default: "any"
  end
end
