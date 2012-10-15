class RemoveActivityFromMembers < ActiveRecord::Migration
  def up
    remove_column :members, :activity
  end

  def down
    add_column :members, :activity
  end
end
