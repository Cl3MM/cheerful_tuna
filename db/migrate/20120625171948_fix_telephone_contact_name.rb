class FixTelephoneContactName < ActiveRecord::Migration
  def change
    rename_column :contacts, :telphone, :phone
  end
end
