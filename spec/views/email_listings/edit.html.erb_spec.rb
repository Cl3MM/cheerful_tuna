require 'spec_helper'

describe "email_listings/edit" do
  before(:each) do
    @email_listing = assign(:email_listing, stub_model(EmailListing))
  end

  it "renders the edit email_listing form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => email_listings_path(@email_listing), :method => "post" do
    end
  end
end
