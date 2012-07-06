class AddIndexesToEmails < ActiveRecord::Migration
  def change
    #ids = Contact.all.map(&:id)
    #Email.all.map{|m| m.destroy unless ids.include?(m.contact_id)}.compact

    add_index :emails, :address, unique: true
    add_index :emails, :contact_id
  end
end
