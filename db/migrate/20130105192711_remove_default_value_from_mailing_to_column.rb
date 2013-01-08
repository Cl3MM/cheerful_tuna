class RemoveDefaultValueFromMailingToColumn < ActiveRecord::Migration
  def up
    change_column_default(:mailings, :to, nil)
  end

  def down
    change_column_default(:mailings, :to, "contact@ceres-recycle.org")
  end
end
