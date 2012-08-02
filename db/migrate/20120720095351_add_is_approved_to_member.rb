class AddIsApprovedToMember < ActiveRecord::Migration
  def change
    add_column :members, :is_approved, :boolean, :default => false, :null => false
    add_index  :members, :is_approved
  end
end
