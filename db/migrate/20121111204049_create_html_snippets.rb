class CreateHtmlSnippets < ActiveRecord::Migration
  def change
    create_table :html_snippets do |t|
      t.string :name, null: false
      t.text   :snippets, null: false
      t.string :view_path, null: false

      t.timestamps
    end
    add_index :html_snippets, :name
  end
end
