class FixSendtForMailings < ActiveRecord::Migration
  def up
    rename_column :mailings, :sendt_at, :send_at
    change_column :mailings, :send_at,  :time
  end

  def down
    change_column :mailings, :send_at, :date
    rename_column :mailings, :send_at, :sendt_at
  end
end
