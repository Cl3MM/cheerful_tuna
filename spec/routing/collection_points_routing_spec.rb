require "spec_helper"

describe CollectionPointsController do
  describe "routing" do

    it "routes to #index" do
      get("/collection_points").should route_to("collection_points#index")
    end

    it "routes to #new" do
      get("/collection_points/new").should route_to("collection_points#new")
    end

    it "routes to #show" do
      get("/collection_points/1").should route_to("collection_points#show", :id => "1")
    end

    it "routes to #edit" do
      get("/collection_points/1/edit").should route_to("collection_points#edit", :id => "1")
    end

    it "routes to #create" do
      post("/collection_points").should route_to("collection_points#create")
    end

    it "routes to #update" do
      put("/collection_points/1").should route_to("collection_points#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/collection_points/1").should route_to("collection_points#destroy", :id => "1")
    end

  end
end
