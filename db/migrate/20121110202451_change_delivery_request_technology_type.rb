class ChangeDeliveryRequestTechnologyType < ActiveRecord::Migration
  def up
    remove_column :delivery_requests, :crystalline_silicon
    remove_column :delivery_requests, :amorphous_micromorph_silicon
    remove_column :delivery_requests, :laminates_flexible_modules
    remove_column :delivery_requests, :concentration_PV
    remove_column :delivery_requests, :CIGS
    remove_column :delivery_requests, :CdTe
    add_column :delivery_requests, :technology, :string, limit: 100, null: false
  end

  def down
    add_column :delivery_requests do |t|
      t.integer :crystalline_silicon
      t.integer :amorphous_micromorph_silicon
      t.integer :laminates_flexible_modules
      t.integer :concentration_PV
      t.integer :CIGS
      t.integer :CdTe
    end
    remove_column :delivery_requests, :technology
  end
end
