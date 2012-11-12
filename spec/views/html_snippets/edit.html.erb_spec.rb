require 'spec_helper'

describe "html_snippets/edit" do
  before(:each) do
    @html_snippet = assign(:html_snippet, stub_model(HtmlSnippet,
      :name => "MyString",
      :snippets => "MyString",
      :view_path => "MyString"
    ))
  end

  it "renders the edit html_snippet form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => html_snippets_path(@html_snippet), :method => "post" do
      assert_select "input#html_snippet_name", :name => "html_snippet[name]"
      assert_select "input#html_snippet_snippets", :name => "html_snippet[snippets]"
      assert_select "input#html_snippet_view_path", :name => "html_snippet[view_path]"
    end
  end
end
