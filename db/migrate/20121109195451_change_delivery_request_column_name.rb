class ChangeDeliveryRequestColumnName < ActiveRecord::Migration
  def up
    rename_column :delivery_requests, :witdh, :width
  end

  def down
    rename_column :delivery_requests, :width, :witdh
  end
end
