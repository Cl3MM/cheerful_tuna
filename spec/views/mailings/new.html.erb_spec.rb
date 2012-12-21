require 'spec_helper'

describe "mailings/new" do
  before(:each) do
    assign(:mailing, stub_model(Mailing,
      :subject => "MyString",
      :template => "MyString",
      :status => "MyString",
      :html_version => "MyString"
    ).as_new_record)
  end

  it "renders new mailing form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => mailings_path, :method => "post" do
      assert_select "input#mailing_subject", :name => "mailing[subject]"
      assert_select "input#mailing_template", :name => "mailing[template]"
      assert_select "input#mailing_status", :name => "mailing[status]"
      assert_select "input#mailing_html_version", :name => "mailing[html_version]"
    end
  end
end
