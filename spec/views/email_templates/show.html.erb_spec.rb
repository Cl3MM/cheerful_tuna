require 'spec_helper'

describe "email_templates/show" do
  before(:each) do
    @email_template = assign(:email_template, stub_model(EmailTemplate,
      :name => "Name",
      :language => "Language",
      :content => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Language/)
    rendered.should match(/MyText/)
  end
end
