require 'spec_helper'

describe "html_snippets/show" do
  before(:each) do
    @html_snippet = assign(:html_snippet, stub_model(HtmlSnippet,
      :name => "Name",
      :snippets => "Snippets",
      :view_path => "View Path"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Snippets/)
    rendered.should match(/View Path/)
  end
end
