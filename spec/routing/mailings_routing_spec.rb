require "spec_helper"

describe MailingsController do
  describe "routing" do

    it "routes to #index" do
      get("/mailings").should route_to("mailings#index")
    end

    it "routes to #new" do
      get("/mailings/new").should route_to("mailings#new")
    end

    it "routes to #show" do
      get("/mailings/1").should route_to("mailings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/mailings/1/edit").should route_to("mailings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/mailings").should route_to("mailings#create")
    end

    it "routes to #update" do
      put("/mailings/1").should route_to("mailings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/mailings/1").should route_to("mailings#destroy", :id => "1")
    end

  end
end
