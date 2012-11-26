class AddCollectionPointIdToDeliveryRequests < ActiveRecord::Migration
  def change
    add_column :delivery_requests, :collection_point_id, :integer
  end
end
