require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe MailingsController do

  # This should return the minimal set of attributes required to create a valid
  # Mailing. As you add validations to Mailing, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "subject" => "MyString" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MailingsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all mailings as @mailings" do
      mailing = Mailing.create! valid_attributes
      get :index, {}, valid_session
      assigns(:mailings).should eq([mailing])
    end
  end

  describe "GET show" do
    it "assigns the requested mailing as @mailing" do
      mailing = Mailing.create! valid_attributes
      get :show, {:id => mailing.to_param}, valid_session
      assigns(:mailing).should eq(mailing)
    end
  end

  describe "GET new" do
    it "assigns a new mailing as @mailing" do
      get :new, {}, valid_session
      assigns(:mailing).should be_a_new(Mailing)
    end
  end

  describe "GET edit" do
    it "assigns the requested mailing as @mailing" do
      mailing = Mailing.create! valid_attributes
      get :edit, {:id => mailing.to_param}, valid_session
      assigns(:mailing).should eq(mailing)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Mailing" do
        expect {
          post :create, {:mailing => valid_attributes}, valid_session
        }.to change(Mailing, :count).by(1)
      end

      it "assigns a newly created mailing as @mailing" do
        post :create, {:mailing => valid_attributes}, valid_session
        assigns(:mailing).should be_a(Mailing)
        assigns(:mailing).should be_persisted
      end

      it "redirects to the created mailing" do
        post :create, {:mailing => valid_attributes}, valid_session
        response.should redirect_to(Mailing.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved mailing as @mailing" do
        # Trigger the behavior that occurs when invalid params are submitted
        Mailing.any_instance.stub(:save).and_return(false)
        post :create, {:mailing => { "subject" => "invalid value" }}, valid_session
        assigns(:mailing).should be_a_new(Mailing)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Mailing.any_instance.stub(:save).and_return(false)
        post :create, {:mailing => { "subject" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested mailing" do
        mailing = Mailing.create! valid_attributes
        # Assuming there are no other mailings in the database, this
        # specifies that the Mailing created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Mailing.any_instance.should_receive(:update_attributes).with({ "subject" => "MyString" })
        put :update, {:id => mailing.to_param, :mailing => { "subject" => "MyString" }}, valid_session
      end

      it "assigns the requested mailing as @mailing" do
        mailing = Mailing.create! valid_attributes
        put :update, {:id => mailing.to_param, :mailing => valid_attributes}, valid_session
        assigns(:mailing).should eq(mailing)
      end

      it "redirects to the mailing" do
        mailing = Mailing.create! valid_attributes
        put :update, {:id => mailing.to_param, :mailing => valid_attributes}, valid_session
        response.should redirect_to(mailing)
      end
    end

    describe "with invalid params" do
      it "assigns the mailing as @mailing" do
        mailing = Mailing.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Mailing.any_instance.stub(:save).and_return(false)
        put :update, {:id => mailing.to_param, :mailing => { "subject" => "invalid value" }}, valid_session
        assigns(:mailing).should eq(mailing)
      end

      it "re-renders the 'edit' template" do
        mailing = Mailing.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Mailing.any_instance.stub(:save).and_return(false)
        put :update, {:id => mailing.to_param, :mailing => { "subject" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested mailing" do
      mailing = Mailing.create! valid_attributes
      expect {
        delete :destroy, {:id => mailing.to_param}, valid_session
      }.to change(Mailing, :count).by(-1)
    end

    it "redirects to the mailings list" do
      mailing = Mailing.create! valid_attributes
      delete :destroy, {:id => mailing.to_param}, valid_session
      response.should redirect_to(mailings_url)
    end
  end

end
