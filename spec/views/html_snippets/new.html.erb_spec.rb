require 'spec_helper'

describe "html_snippets/new" do
  before(:each) do
    assign(:html_snippet, stub_model(HtmlSnippet,
      :name => "MyString",
      :snippets => "MyString",
      :view_path => "MyString"
    ).as_new_record)
  end

  it "renders new html_snippet form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => html_snippets_path, :method => "post" do
      assert_select "input#html_snippet_name", :name => "html_snippet[name]"
      assert_select "input#html_snippet_snippets", :name => "html_snippet[snippets]"
      assert_select "input#html_snippet_view_path", :name => "html_snippet[view_path]"
    end
  end
end
