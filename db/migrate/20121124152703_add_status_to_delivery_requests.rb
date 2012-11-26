class AddStatusToDeliveryRequests < ActiveRecord::Migration
  def change
    add_column  :delivery_requests, :status, :string, default: "open"
    add_index   :delivery_requests, :status
  end
end
