require "spec_helper"

describe DeliveryRequestsController do
  describe "routing" do

    it "routes to #index" do
      get("/delivery_requests").should route_to("delivery_requests#index")
    end

    it "routes to #new" do
      get("/joomla/delivery_request").should route_to("delivery_requests#new")
    end

    it "routes to #show" do
      get("/delivery_requests/1").should route_to("delivery_requests#show", :id => "1")
    end

    it "routes to #edit" do
      create :delivery_request
      #{ get => "/products/1/edit" }.should_not be_routable
      #get("/delivery_requests/1/edit").should route_to("delivery_requests#edit", :id => "1")
      get("/delivery_requests/1/edit").should_not be_routable
    end

    it "routes to #create" do
      post("/delivery_requests").should route_to("delivery_requests#create")
    end

    it "routes to #update" do
      put("/delivery_requests/1").should_not be_routable
    end

    it "routes to #destroy" do
      delete("/delivery_requests/1").should route_to("delivery_requests#destroy", :id => "1")
    end

  end
end
