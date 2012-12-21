class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title, unique: true
      t.text :content, unique: true

      t.timestamps
    end
    add_index :articles, :title
  end
end
