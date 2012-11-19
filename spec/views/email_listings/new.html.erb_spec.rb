require 'spec_helper'

describe "email_listings/new" do
  before(:each) do
    assign(:email_listing, stub_model(EmailListing).as_new_record)
  end

  it "renders new email_listing form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => email_listings_path, :method => "post" do
    end
  end
end
