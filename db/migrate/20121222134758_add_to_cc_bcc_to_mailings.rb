class AddToCcBccToMailings < ActiveRecord::Migration
  def change
    add_column :mailings, :to, :string, default: "contact@ceres-recycle.org"
    add_column :mailings, :cc, :string
    add_column :mailings, :bcc, :string
    add_index  :mailings, :to
    add_index  :mailings, :cc
    add_index  :mailings, :bcc
  end
end
