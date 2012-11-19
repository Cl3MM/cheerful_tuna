require 'spec_helper'

describe HtmlSnippetsController do

  login_admin

  def valid_attributes
    attributes_for(:member)
  end

  def valid_session
  end

  describe "GET index" do
    it "assigns all html_snippets as @html_snippets" do
      html_snippet = HtmlSnippet.create! valid_attributes
      get :index, {}
      assigns(:html_snippets).should eq([html_snippet])
    end
  end

  describe "GET show" do
    it "assigns the requested html_snippet as @html_snippet" do
      html_snippet = HtmlSnippet.create! valid_attributes
      get :show, {:id => html_snippet.to_param}
      assigns(:html_snippet).should eq(html_snippet)
    end
  end

  describe "GET new" do
    it "assigns a new html_snippet as @html_snippet" do
      get :new, {}
      assigns(:html_snippet).should be_a_new(HtmlSnippet)
    end
  end

  describe "GET edit" do
    it "assigns the requested html_snippet as @html_snippet" do
      html_snippet = HtmlSnippet.create! valid_attributes
      get :edit, {:id => html_snippet.to_param}
      assigns(:html_snippet).should eq(html_snippet)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new HtmlSnippet" do
        expect {
          post :create, {:html_snippet => valid_attributes}
        }.to change(HtmlSnippet, :count).by(1)
      end

      it "assigns a newly created html_snippet as @html_snippet" do
        post :create, {:html_snippet => valid_attributes}
        assigns(:html_snippet).should be_a(HtmlSnippet)
        assigns(:html_snippet).should be_persisted
      end

      it "redirects to the created html_snippet" do
        post :create, {:html_snippet => valid_attributes}
        response.should redirect_to(HtmlSnippet.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved html_snippet as @html_snippet" do
        # Trigger the behavior that occurs when invalid params are submitted
        HtmlSnippet.any_instance.stub(:save).and_return(false)
        post :create, {:html_snippet => {}}
        assigns(:html_snippet).should be_a_new(HtmlSnippet)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        HtmlSnippet.any_instance.stub(:save).and_return(false)
        post :create, {:html_snippet => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested html_snippet" do
        html_snippet = HtmlSnippet.create! valid_attributes
        # Assuming there are no other html_snippets in the database, this
        # specifies that the HtmlSnippet created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        HtmlSnippet.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => html_snippet.to_param, :html_snippet => {'these' => 'params'}}
      end

      it "assigns the requested html_snippet as @html_snippet" do
        html_snippet = HtmlSnippet.create! valid_attributes
        put :update, {:id => html_snippet.to_param, :html_snippet => valid_attributes}
        assigns(:html_snippet).should eq(html_snippet)
      end

      it "redirects to the html_snippet" do
        html_snippet = HtmlSnippet.create! valid_attributes
        put :update, {:id => html_snippet.to_param, :html_snippet => valid_attributes}
        response.should redirect_to(html_snippet)
      end
    end

    describe "with invalid params" do
      it "assigns the html_snippet as @html_snippet" do
        html_snippet = HtmlSnippet.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        HtmlSnippet.any_instance.stub(:save).and_return(false)
        put :update, {:id => html_snippet.to_param, :html_snippet => {}}
        assigns(:html_snippet).should eq(html_snippet)
      end

      it "re-renders the 'edit' template" do
        html_snippet = HtmlSnippet.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        HtmlSnippet.any_instance.stub(:save).and_return(false)
        put :update, {:id => html_snippet.to_param, :html_snippet => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested html_snippet" do
      html_snippet = HtmlSnippet.create! valid_attributes
      expect {
        delete :destroy, {:id => html_snippet.to_param}
      }.to change(HtmlSnippet, :count).by(-1)
    end

    it "redirects to the html_snippets list" do
      html_snippet = HtmlSnippet.create! valid_attributes
      delete :destroy, {:id => html_snippet.to_param}
      response.should redirect_to(html_snippets_url)
    end
  end

end
