require 'spec_helper'

describe Joomla::UsersController do

  login_admin

  def valid_attributes
    attributes_for(:joomla_user)
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all joomla_users as @joomla_users" do
      joomla_user = JoomlaUser.create! valid_attributes
      get :index, {}
      assigns(:joomla_users).should eq([joomla_user])
    end
  end

  describe "GET show" do
    it "assigns the requested joomla_user as @joomla_user" do
      joomla_user = JoomlaUser.create! valid_attributes
      get :show, {:id => joomla_user.to_param}
      assigns(:joomla_user).should eq(joomla_user)
    end
  end

  describe "GET new" do
    it "assigns a new joomla_user as @joomla_user" do
      get :new, {}
      assigns(:joomla_user).should be_a_new(JoomlaUser)
    end
  end

  describe "GET edit" do
    it "assigns the requested joomla_user as @joomla_user" do
      joomla_user = JoomlaUser.create! valid_attributes
      get :edit, {:id => joomla_user.to_param}
      assigns(:joomla_user).should eq(joomla_user)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new JoomlaUser" do
        expect {
          post :create, {:joomla_user => valid_attributes}
        }.to change(JoomlaUser, :count).by(1)
      end

      it "assigns a newly created joomla_user as @joomla_user" do
        post :create, {:joomla_user => valid_attributes}
        assigns(:joomla_user).should be_a(JoomlaUser)
        assigns(:joomla_user).should be_persisted
      end

      it "redirects to the created joomla_user" do
        post :create, {:joomla_user => valid_attributes}
        response.should redirect_to(JoomlaUser.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved joomla_user as @joomla_user" do
        # Trigger the behavior that occurs when invalid params are submitted
        JoomlaUser.any_instance.stub(:save).and_return(false)
        post :create, {:joomla_user => {}}
        assigns(:joomla_user).should be_a_new(JoomlaUser)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        JoomlaUser.any_instance.stub(:save).and_return(false)
        post :create, {:joomla_user => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested joomla_user" do
        joomla_user = JoomlaUser.create! valid_attributes
        # Assuming there are no other joomla_users in the database, this
        # specifies that the JoomlaUser created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        JoomlaUser.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => joomla_user.to_param, :joomla_user => {'these' => 'params'}}
      end

      it "assigns the requested joomla_user as @joomla_user" do
        joomla_user = JoomlaUser.create! valid_attributes
        put :update, {:id => joomla_user.to_param, :joomla_user => valid_attributes}
        assigns(:joomla_user).should eq(joomla_user)
      end

      it "redirects to the joomla_user" do
        joomla_user = JoomlaUser.create! valid_attributes
        put :update, {:id => joomla_user.to_param, :joomla_user => valid_attributes}
        response.should redirect_to(joomla_user)
      end
    end

    describe "with invalid params" do
      it "assigns the joomla_user as @joomla_user" do
        joomla_user = JoomlaUser.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        JoomlaUser.any_instance.stub(:save).and_return(false)
        put :update, {:id => joomla_user.to_param, :joomla_user => {}}
        assigns(:joomla_user).should eq(joomla_user)
      end

      it "re-renders the 'edit' template" do
        joomla_user = JoomlaUser.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        JoomlaUser.any_instance.stub(:save).and_return(false)
        put :update, {:id => joomla_user.to_param, :joomla_user => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested joomla_user" do
      joomla_user = JoomlaUser.create! valid_attributes
      expect {
        delete :destroy, {:id => joomla_user.to_param}
      }.to change(JoomlaUser, :count).by(-1)
    end

    it "redirects to the joomla_users list" do
      joomla_user = JoomlaUser.create! valid_attributes
      delete :destroy, {:id => joomla_user.to_param}
      response.should redirect_to(joomla_users_url)
    end
  end

end
