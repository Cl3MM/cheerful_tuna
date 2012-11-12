require "spec_helper"

describe HtmlSnippetsController do
  describe "routing" do

    it "routes to #index" do
      get("/html_snippets").should route_to("html_snippets#index")
    end

    it "routes to #new" do
      get("/html_snippets/new").should route_to("html_snippets#new")
    end

    it "routes to #show" do
      get("/html_snippets/1").should route_to("html_snippets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/html_snippets/1/edit").should route_to("html_snippets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/html_snippets").should route_to("html_snippets#create")
    end

    it "routes to #update" do
      put("/html_snippets/1").should route_to("html_snippets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/html_snippets/1").should route_to("html_snippets#destroy", :id => "1")
    end

  end
end
