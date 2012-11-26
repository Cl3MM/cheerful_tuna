class AddStatusToCollectionPoints < ActiveRecord::Migration
  def change
    add_column :collection_points, :status, :string, default: "operational"
    add_column :collection_points, :ceres_member, :boolean, default: false
    add_index  :collection_points, :status
  end
end
