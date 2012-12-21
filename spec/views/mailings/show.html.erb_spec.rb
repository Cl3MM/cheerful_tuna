require 'spec_helper'

describe "mailings/show" do
  before(:each) do
    @mailing = assign(:mailing, stub_model(Mailing,
      :subject => "Subject",
      :template => "Template",
      :status => "Status",
      :html_version => "Html Version"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Subject/)
    rendered.should match(/Template/)
    rendered.should match(/Status/)
    rendered.should match(/Html Version/)
  end
end
