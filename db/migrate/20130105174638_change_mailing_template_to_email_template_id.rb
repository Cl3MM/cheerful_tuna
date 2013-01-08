class ChangeMailingTemplateToEmailTemplateId < ActiveRecord::Migration
  def up
    rename_column :mailings, :template, :email_template_id
    change_column :mailings, :email_template_id, :integer
  end

  def down
    change_column :mailings, :email_template_id, :string
    rename_column :mailings, :email_template_id, :template
  end
end
