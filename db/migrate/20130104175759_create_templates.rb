class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name
      t.string :language
      t.text :content

      t.timestamps
    end
    add_index :templates, :name
  end
end
