require 'spec_helper'

describe EmailListingsController do

  login_admin

  def valid_attributes
    attributes_for(:email_listing)
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all email_listings as @email_listings" do
      email_listing = EmailListing.create! valid_attributes
      get :index, {}, valid_session
      assigns(:email_listings).should eq([email_listing])
    end
  end

  describe "GET show" do
    it "assigns the requested email_listing as @email_listing" do
      email_listing = EmailListing.create! valid_attributes
      get :show, {:id => email_listing.to_param}, valid_session
      assigns(:email_listing).should eq(email_listing)
    end
  end

  describe "GET new" do
    it "assigns a new email_listing as @email_listing" do
      get :new, {}, valid_session
      assigns(:email_listing).should be_a_new(EmailListing)
    end
  end

  describe "GET edit" do
    it "assigns the requested email_listing as @email_listing" do
      email_listing = EmailListing.create! valid_attributes
      get :edit, {:id => email_listing.to_param}, valid_session
      assigns(:email_listing).should eq(email_listing)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new EmailListing" do
        expect {
          post :create, {:email_listing => valid_attributes}, valid_session
        }.to change(EmailListing, :count).by(1)
      end

      it "assigns a newly created email_listing as @email_listing" do
        post :create, {:email_listing => valid_attributes}, valid_session
        assigns(:email_listing).should be_a(EmailListing)
        assigns(:email_listing).should be_persisted
      end

      it "redirects to the created email_listing" do
        post :create, {:email_listing => valid_attributes}, valid_session
        response.should redirect_to(EmailListing.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved email_listing as @email_listing" do
        # Trigger the behavior that occurs when invalid params are submitted
        EmailListing.any_instance.stub(:save).and_return(false)
        post :create, {:email_listing => {}}, valid_session
        assigns(:email_listing).should be_a_new(EmailListing)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        EmailListing.any_instance.stub(:save).and_return(false)
        post :create, {:email_listing => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested email_listing" do
        email_listing = EmailListing.create! valid_attributes
        # Assuming there are no other email_listings in the database, this
        # specifies that the EmailListing created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        EmailListing.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => email_listing.to_param, :email_listing => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested email_listing as @email_listing" do
        email_listing = EmailListing.create! valid_attributes
        put :update, {:id => email_listing.to_param, :email_listing => valid_attributes}, valid_session
        assigns(:email_listing).should eq(email_listing)
      end

      it "redirects to the email_listing" do
        email_listing = EmailListing.create! valid_attributes
        put :update, {:id => email_listing.to_param, :email_listing => valid_attributes}, valid_session
        response.should redirect_to(email_listing)
      end
    end

    describe "with invalid params" do
      it "assigns the email_listing as @email_listing" do
        email_listing = EmailListing.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        EmailListing.any_instance.stub(:save).and_return(false)
        put :update, {:id => email_listing.to_param, :email_listing => {}}, valid_session
        assigns(:email_listing).should eq(email_listing)
      end

      it "re-renders the 'edit' template" do
        email_listing = EmailListing.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        EmailListing.any_instance.stub(:save).and_return(false)
        put :update, {:id => email_listing.to_param, :email_listing => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested email_listing" do
      email_listing = EmailListing.create! valid_attributes
      expect {
        delete :destroy, {:id => email_listing.to_param}, valid_session
      }.to change(EmailListing, :count).by(-1)
    end

    it "redirects to the email_listings list" do
      email_listing = EmailListing.create! valid_attributes
      delete :destroy, {:id => email_listing.to_param}, valid_session
      response.should redirect_to(email_listings_url)
    end
  end

end
