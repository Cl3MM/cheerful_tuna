require 'spec_helper'

describe "mailings/edit" do
  before(:each) do
    @mailing = assign(:mailing, stub_model(Mailing,
      :subject => "MyString",
      :template => "MyString",
      :status => "MyString",
      :html_version => "MyString"
    ))
  end

  it "renders the edit mailing form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => mailings_path(@mailing), :method => "post" do
      assert_select "input#mailing_subject", :name => "mailing[subject]"
      assert_select "input#mailing_template", :name => "mailing[template]"
      assert_select "input#mailing_status", :name => "mailing[status]"
      assert_select "input#mailing_html_version", :name => "mailing[html_version]"
    end
  end
end
