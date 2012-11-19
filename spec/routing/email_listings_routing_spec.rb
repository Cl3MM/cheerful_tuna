require "spec_helper"

describe EmailListingsController do
  describe "routing" do

    it "routes to #index" do
      get("/email_listings").should route_to("email_listings#index")
    end

    it "routes to #new" do
      get("/email_listings/new").should route_to("email_listings#new")
    end

    it "routes to #show" do
      get("/email_listings/1").should route_to("email_listings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/email_listings/1/edit").should route_to("email_listings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/email_listings").should route_to("email_listings#create")
    end

    it "routes to #update" do
      put("/email_listings/1").should route_to("email_listings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/email_listings/1").should route_to("email_listings#destroy", :id => "1")
    end

  end
end
