class AddCountriesToMailings < ActiveRecord::Migration
  def change
    add_column :mailings, :countries, :string
    add_column :mailings, :tags,      :string
  end
end
