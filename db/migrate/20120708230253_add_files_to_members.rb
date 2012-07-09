class AddFilesToMembers < ActiveRecord::Migration
  def change
    add_column :members, :membership_file, :string
    add_column :members, :logo_file, :string
  end
end
