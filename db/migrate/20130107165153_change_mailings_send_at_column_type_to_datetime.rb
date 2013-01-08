class ChangeMailingsSendAtColumnTypeToDatetime < ActiveRecord::Migration
  def up
    change_column :mailings, :send_at, :datetime
  end

  def down
    change_column :mailings, :send_at, :time
  end
end
