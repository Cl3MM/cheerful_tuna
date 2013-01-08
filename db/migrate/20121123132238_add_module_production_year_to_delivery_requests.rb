class AddModuleProductionYearToDeliveryRequests < ActiveRecord::Migration
  def change
    if Rails.env.test?
      add_column :delivery_requests, :modules_production_year, :integer
    else
      add_column :delivery_requests, :modules_production_year, :integer, null: false
    end
  end
end
