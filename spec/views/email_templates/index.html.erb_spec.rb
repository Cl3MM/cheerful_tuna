require 'spec_helper'

describe "email_templates/index" do
  before(:each) do
    assign(:email_templates, [
      stub_model(EmailTemplate,
        :name => "Name",
        :language => "Language",
        :content => "MyText"
      ),
      stub_model(EmailTemplate,
        :name => "Name",
        :language => "Language",
        :content => "MyText"
      )
    ])
  end

  it "renders a list of email_templates" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Language".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
