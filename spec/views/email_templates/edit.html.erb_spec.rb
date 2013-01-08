require 'spec_helper'

describe "email_templates/edit" do
  before(:each) do
    @email_template = assign(:email_template, stub_model(EmailTemplate,
      :name => "MyString",
      :language => "MyString",
      :content => "MyText"
    ))
  end

  it "renders the edit email_template form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => email_templates_path(@email_template), :method => "post" do
      assert_select "input#email_template_name", :name => "email_template[name]"
      assert_select "input#email_template_language", :name => "email_template[language]"
      assert_select "textarea#email_template_content", :name => "email_template[content]"
    end
  end
end
