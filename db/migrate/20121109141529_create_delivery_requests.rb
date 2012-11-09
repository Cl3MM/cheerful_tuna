class CreateDeliveryRequests < ActiveRecord::Migration
  def change
    create_table :delivery_requests do |t|
      t.string  :name, limit: 120, null: false
      t.string  :company, limit: 120
      t.string  :email, limit: 70, null: false
      t.string  :telephone, limit: 40
      t.string  :address
      t.string  :postal_code, limit: 30
      t.string  :city
      t.float   :longitude
      t.float   :latitude
      t.string  :country
      t.integer :module_count
      t.string  :serial_numbers
      t.string  :manufacturers
      t.integer :crystalline_silicon
      t.integer :amorphous_micromorph_silicon
      t.integer :laminates_flexible_modules
      t.integer :concentration_PV
      t.integer :CIGS
      t.integer :CdTe
      t.decimal :length, precision: 10, scale: 3
      t.decimal :witdh, precision: 10, scale: 3
      t.decimal :height, precision: 10, scale: 3
      t.decimal :weight, precision: 20, scale: 3
      t.string  :reason_of_disposal
      t.string  :modules_condition
      t.integer :pallets_number
      t.text    :comments
      t.string  :user_ip, limit: 20, null: false
      t.string  :user_agent, null: false
      t.string  :referer, null: false
      t.float   :ip_lat
      t.float   :ip_long
      t.timestamps
    end
  end
end
