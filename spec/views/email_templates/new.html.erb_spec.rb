require 'spec_helper'

describe "email_templates/new" do
  before(:each) do
    assign(:email_template, stub_model(EmailTemplate,
      :name => "MyString",
      :language => "MyString",
      :content => "MyText"
    ).as_new_record)
  end

  it "renders new email_template form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => email_templates_path, :method => "post" do
      assert_select "input#email_template_name", :name => "email_template[name]"
      assert_select "input#email_template_language", :name => "email_template[language]"
      assert_select "textarea#email_template_content", :name => "email_template[content]"
    end
  end
end
