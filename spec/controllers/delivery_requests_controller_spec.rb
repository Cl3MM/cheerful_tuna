require 'spec_helper'

describe DeliveryRequestsController do

  login_admin

  def valid_attributes
    attributes_for(:delivery_request)
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all delivery_requests as @delivery_requests" do
      delivery_request = DeliveryRequest.create! valid_attributes
      get :index, {}, valid_session
      assigns(:delivery_requests).should eq([delivery_request])
    end
  end

  describe "GET show" do
    it "assigns the requested delivery_request as @delivery_request" do
      delivery_request = DeliveryRequest.create! valid_attributes
      get :show, {:id => delivery_request.to_param}, valid_session
      assigns(:delivery_request).should eq(delivery_request)
    end
  end

  describe "GET new" do
    it "assigns a new delivery_request as @delivery_request" do
      get :new, {}, valid_session
      assigns(:delivery_request).should be_a_new(DeliveryRequest)
    end
  end

  describe "GET edit" do
    it "assigns the requested delivery_request as @delivery_request" do
      delivery_request = DeliveryRequest.create! valid_attributes
      get :edit, {:id => delivery_request.to_param}, valid_session
      assigns(:delivery_request).should eq(delivery_request)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new DeliveryRequest" do
        expect {
          post :create, {:delivery_request => valid_attributes}, valid_session
        }.to change(DeliveryRequest, :count).by(1)
      end

      it "assigns a newly created delivery_request as @delivery_request" do
        post :create, {:delivery_request => valid_attributes}, valid_session
        assigns(:delivery_request).should be_a(DeliveryRequest)
        assigns(:delivery_request).should be_persisted
      end

      it "redirects to the created delivery_request" do
        post :create, {:delivery_request => valid_attributes}, valid_session
        response.should redirect_to(DeliveryRequest.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved delivery_request as @delivery_request" do
        # Trigger the behavior that occurs when invalid params are submitted
        DeliveryRequest.any_instance.stub(:save).and_return(false)
        post :create, {:delivery_request => {}}, valid_session
        assigns(:delivery_request).should be_a_new(DeliveryRequest)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        DeliveryRequest.any_instance.stub(:save).and_return(false)
        post :create, {:delivery_request => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested delivery_request" do
        delivery_request = DeliveryRequest.create! valid_attributes
        # Assuming there are no other delivery_requests in the database, this
        # specifies that the DeliveryRequest created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        DeliveryRequest.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => delivery_request.to_param, :delivery_request => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested delivery_request as @delivery_request" do
        delivery_request = DeliveryRequest.create! valid_attributes
        put :update, {:id => delivery_request.to_param, :delivery_request => valid_attributes}, valid_session
        assigns(:delivery_request).should eq(delivery_request)
      end

      it "redirects to the delivery_request" do
        delivery_request = DeliveryRequest.create! valid_attributes
        put :update, {:id => delivery_request.to_param, :delivery_request => valid_attributes}, valid_session
        response.should redirect_to(delivery_request)
      end
    end

    describe "with invalid params" do
      it "assigns the delivery_request as @delivery_request" do
        delivery_request = DeliveryRequest.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        DeliveryRequest.any_instance.stub(:save).and_return(false)
        put :update, {:id => delivery_request.to_param, :delivery_request => {}}, valid_session
        assigns(:delivery_request).should eq(delivery_request)
      end

      it "re-renders the 'edit' template" do
        delivery_request = DeliveryRequest.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        DeliveryRequest.any_instance.stub(:save).and_return(false)
        put :update, {:id => delivery_request.to_param, :delivery_request => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested delivery_request" do
      delivery_request = DeliveryRequest.create! valid_attributes
      expect {
        delete :destroy, {:id => delivery_request.to_param}, valid_session
      }.to change(DeliveryRequest, :count).by(-1)
    end

    it "redirects to the delivery_requests list" do
      delivery_request = DeliveryRequest.create! valid_attributes
      delete :destroy, {:id => delivery_request.to_param}, valid_session
      response.should redirect_to(delivery_requests_url)
    end
  end

end
