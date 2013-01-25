class AddStatusToMembers < ActiveRecord::Migration
  def change
    add_column :members, :status, :string, default: :pending
    Member.all.each do |m|
      m.update_attribute :status, :pending
    end
  end
end
