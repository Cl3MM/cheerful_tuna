class CreateArticlesMailingsTable < ActiveRecord::Migration
  def up
    create_table :articles_mailings, :id => false do |t|
        t.references :article
        t.references :mailing
    end
    add_index :articles_mailings, [:article_id, :mailing_id]
  end

  def down
    drop_table :articles_mailings
  end
end
