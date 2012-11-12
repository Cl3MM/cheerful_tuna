require 'spec_helper'

describe "html_snippets/index" do
  before(:each) do
    assign(:html_snippets, [
      stub_model(HtmlSnippet,
        :name => "Name",
        :snippets => "Snippets",
        :view_path => "View Path"
      ),
      stub_model(HtmlSnippet,
        :name => "Name",
        :snippets => "Snippets",
        :view_path => "View Path"
      )
    ])
  end

  it "renders a list of html_snippets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Snippets".to_s, :count => 2
    assert_select "tr>td", :text => "View Path".to_s, :count => 2
  end
end
