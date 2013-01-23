class AddAddressContinuedToMembers < ActiveRecord::Migration
  def change
    add_column :members, :address_continued, :string
  end
end
