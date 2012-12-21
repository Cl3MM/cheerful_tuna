require 'spec_helper'

describe "mailings/index" do
  before(:each) do
    assign(:mailings, [
      stub_model(Mailing,
        :subject => "Subject",
        :template => "Template",
        :status => "Status",
        :html_version => "Html Version"
      ),
      stub_model(Mailing,
        :subject => "Subject",
        :template => "Template",
        :status => "Status",
        :html_version => "Html Version"
      )
    ])
  end

  it "renders a list of mailings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Subject".to_s, :count => 2
    assert_select "tr>td", :text => "Template".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => "Html Version".to_s, :count => 2
  end
end
