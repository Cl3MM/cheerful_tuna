class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :address
      t.integer :contact_id
      t.integer :has_bounced, :default => 0

      t.timestamps
    end
  end
end
