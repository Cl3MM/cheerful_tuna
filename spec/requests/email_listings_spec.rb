require 'spec_helper'

describe "EmailListings" do
  describe "GET /email_listings" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get email_listings_path
      response.status.should be(200)
    end
  end
end
