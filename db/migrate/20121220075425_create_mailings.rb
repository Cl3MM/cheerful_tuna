class CreateMailings < ActiveRecord::Migration
  def change
    create_table :mailings do |t|
      t.string  :subject,       unique: true
      t.string  :template
      t.string  :status
      t.string  :html_version
      t.date    :sendt_at

      t.timestamps
    end
    add_index :mailings, :subject
  end
end
