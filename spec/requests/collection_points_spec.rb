require 'spec_helper'

describe "CollectionPoints" do
  describe "GET /collection_points" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get collection_points_path
      response.status.should be(200)
    end
  end
end
