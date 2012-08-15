class AddWebProfileUrlToMembers < ActiveRecord::Migration
  def change
    add_column :members, :web_profile_url, :string
  end
end
