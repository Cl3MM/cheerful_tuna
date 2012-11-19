require 'spec_helper'

describe "email_listings/index" do
  before(:each) do
    assign(:email_listings, [
      stub_model(EmailListing),
      stub_model(EmailListing)
    ])
  end

  it "renders a list of email_listings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
