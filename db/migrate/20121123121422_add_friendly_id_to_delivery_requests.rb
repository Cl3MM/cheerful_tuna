class AddFriendlyIdToDeliveryRequests < ActiveRecord::Migration
  def change
    if Rails.env.test?
      add_column :delivery_requests, :slug, :string
    else
      add_column :delivery_requests, :slug, :string, null: false
    end
    DeliveryRequest.find_each(&:save)
#    add_column :delivery_requests, :url_hash, :string
    add_index  :delivery_requests, :slug, unique: true
  end
end
