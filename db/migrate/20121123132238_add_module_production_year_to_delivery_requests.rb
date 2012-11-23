class AddModuleProductionYearToDeliveryRequests < ActiveRecord::Migration
  def change
    add_column :delivery_requests, :modules_production_year, :integer, null: false
  end
end
