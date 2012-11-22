class RemoveIndexMembersOnEmail < ActiveRecord::Migration
  def up
    indexes = ActiveRecord::Base.connection.indexes(:members).map(&:name)
    if indexes.include? 'index_members_on_email'
      puts '* Index "index_members_on_email" Found'
      remove_index :members, :email 
    else
      puts '* Index "index_members_on_email" NOT Found'
    end
  end

  def down
    add_index :members, :email
  end
end
