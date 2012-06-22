class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :english
      t.string :french
      t.string :chinese

      t.timestamps
    end
  end
end
