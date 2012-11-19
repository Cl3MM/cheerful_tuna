require 'spec_helper'

describe "email_listings/show" do
  before(:each) do
    @email_listing = assign(:email_listing, stub_model(EmailListing))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
