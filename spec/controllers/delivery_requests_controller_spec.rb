require 'spec_helper'

describe DeliveryRequestsController do

  login_admin

  def valid_attributes
    puts attributes_for(:delivery_request)
    attributes_for(:delivery_request)
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all delivery_requests as @delivery_requests" do
      delivery_request = create :delivery_request
      get :index, {}
      assigns(:delivery_requests).should eq([delivery_request])
    end
  end

  describe "GET show" do
    it "assigns the requested delivery_request as @delivery_request" do
      delivery_request = create :delivery_request
      get :show, {:id => delivery_request.to_param}
      assigns(:delivery_request).should eq(delivery_request)
    end
  end

  describe "GET new" do
    it "assigns a new delivery_request as @delivery_request" do
      get :new, {}
      assigns(:delivery_request).should be_a_new(DeliveryRequest)
    end
  end

  describe "GET edit" do
    it "returns a 404 error" do
      delivery_request = create :delivery_request
      get(:edit, {:id => delivery_request.to_param}).should_not be_routable
    end
  end

  # {
  #  :name=>"Andre Wehner", :email=>"mustafa@buckridge.biz", :address=>"26901 Lesch Fork",
  #  :user_ip=>"134.77.14.163", :postal_code=>"34938", :city=>"Haroldshire", :country=>"Bhutan",
  #  :module_count=>49, :length=>160, :width=>100, :height=>120, :weight=>800, :pallets_number=>4,
  #  :user_agent=>"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11",
  #  :referer=>"http:www.google.fr", :technology=>"cigs", :reason_of_disposal=>"Other", :modules_condition=>"Intact"
  # }

  # Parameters:
  #   {"utf8"=>"✓", "authenticity_token"=>"vvl46vnrciRdOopIe2IfjXUoehl8iwWdKrSXghpOMO0=",
  #   "delivery_request" =>
  #     {
  #       "name"=>"bob", "email"=>"bob@bob.it", "company"=>"", "telephone"=>"",
  #       "address"=>"lkj", "postal_code"=>"lkj", "city"=>"lj", "country"=>"France",
  #       "serial_numbers"=>"", "manufacturers"=>"", "reason_of_disposal"=>"Other",
  #       "modules_condition"=>"Intact", "technology"=>"crystalline_silicon",
  #       "module_count"=>"1", "pallets_number"=>"1", "length"=>"1", "width"=>"1",
  #       "height"=>"1", "weight"=>"1", "comments"=>""
  #     },
  #   "recaptcha_challenge_field"=>"03AHJ_Vuvozl2RRnuteH1aGbu0eVH2TA_E8brKR5H-50raJ7fQ7Fl3rY9IK_hDy7pL4WWLw_KVxq7jaqscllL4cjlhFt_VAK3RGEtRlpaJUbo7GaNUVG4bzc-w448rJ3LyWVX7LjRRJMt4gLOEvwZxC1R_3Z_XtgUiTsyWCHSG1JYFIIcQYf7KZiejS13a2b6LrgLk6HOISwNV", 
  #   "recaptcha_response_field"=>"sfutyn Turner,", "commit"=>"Send Delivery request"}

  #describe "POST create" do
    #describe "with valid params" do
      #it "creates a new DeliveryRequest", focus: true do
        ##valid_attributes = build(:delivery_request).valid_attributes

##x = Hash[*[["address", "898 McGlynn Parkway"], ["city", "Johnsonshire"], ["comments", nil], ["company", nil],
 ##["country", "Syrian Arab Republic"], ["created_at", 'Fri, 16 Nov 2012 20:11:48 UTC +00:00'], 
 ##["email", "catharine.beer@purdy.org"], ["height", "#<BigDecimal:8d7db30,'0.12E3',9(18)>"],
 ##["ip_lat", nil], ["ip_long", nil], ["latitude", nil], ["length", "'#<BigDecimal:8d7dc20,'0.16E3',9(18)>"],
 ##["longitude", nil], ["manufacturers", nil], ["module_count", 26], ["modules_condition", "Intact"],
 ##["name", "Miss Harmon Yundt"], ["pallets_number", 4], ["postal_code", "91351"],
 ##["reason_of_disposal", "Other"], ["referer", nil], ["serial_numbers", nil],
 ##["technology", "cigs"], ["telephone", nil], ["updated_at", "Fri, 16 Nov 2012 20:11:48 UTC +00:00"],
 ##["user_agent", "Rails Testing"], ["user_ip", "0.0.0.0"], ["weight", "<BigDecimal:8d7dab8,'0.8E3',9(18)>"],
 ##["width", "#<BigDecimal:8d7dba8,'0.1E3',9(18)>"]].flatten]

#x = Hash[*[["address", "898 McGlynn Parkway"], ["city", "Johnsonshire"],
 #["country", "Syrian Arab Republic"],
 #["email", "catharine.beer@purdy.org"], ["height", "#<BigDecimal:8d7db30,'0.12E3',9(18)>"],
 #["latitude", nil], ["length", "'#<BigDecimal:8d7dc20,'0.16E3',9(18)>"],
 #["longitude", nil], ["manufacturers", nil], ["module_count", 26], ["modules_condition", "Intact"],
 #["name", "Miss Harmon Yundt"], ["pallets_number", 4], ["postal_code", "91351"],
 #["reason_of_disposal", "Other"], ["referer", nil], ["serial_numbers", nil],
 #["technology", "cigs"], ["telephone", nil],
 #["user_agent", "Rails Testing"], ["user_ip", "0.0.0.0"], ["weight", "<BigDecimal:8d7dab8,'0.8E3',9(18)>"],
 #["width", "#<BigDecimal:8d7dba8,'0.1E3',9(18)>"]].flatten]

        #expect {
          #post :create, :delivery_request => x #valid_attributes.except(:created_at, :updated_at, :id)
        #}.to change(DeliveryRequest, :count).by(1)
      #end

      #it "assigns a newly created delivery_request as @delivery_request" do
        #post :create, :delivery_request => valid_attributes
        #assigns(:delivery_request).should be_a(DeliveryRequest)
        #assigns(:delivery_request).should be_persisted
      #end

      #it "redirects to the created delivery_request" do
        #post :create, :delivery_request => valid_attributes
        #response.should redirect_to(DeliveryRequest.last)
      #end
    #end

    describe "with invalid params" do
      it "assigns a newly created but unsaved delivery_request as @delivery_request" do
        # Trigger the behavior that occurs when invalid params are submitted
        DeliveryRequest.any_instance.stub(:save).and_return(false)
        post :create, {:delivery_request => {}}
        assigns(:delivery_request).should be_a_new(DeliveryRequest)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        DeliveryRequest.any_instance.stub(:save).and_return(false)
        post :create, {:delivery_request => {}}
        response.should render_template("new")
      end
    end
  #end

  #describe "PUT update" do
    #describe "with valid params" do
      #it "updates the requested delivery_request" do
        #delivery_request = create :delivery_request
        ## Assuming there are no other delivery_requests in the database, this
        ## specifies that the DeliveryRequest created on the previous line
        ## receives the :update_attributes message with whatever params are
        ## submitted in the request.
        #DeliveryRequest.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        #put :update, {:id => delivery_request.to_param, :delivery_request => {'these' => 'params'}}
      #end

      #it "assigns the requested delivery_request as @delivery_request" do
        #delivery_request = create :delivery_request
        #put :update, {:id => delivery_request.to_param, :delivery_request => valid_attributes}
        #assigns(:delivery_request).should eq(delivery_request)
      #end

      #it "redirects to the delivery_request" do
        #delivery_request = create :delivery_request
        #put :update, {:id => delivery_request.to_param, :delivery_request => valid_attributes}
        #response.should redirect_to(delivery_request)
      #end
    #end

    #describe "with invalid params" do
      #it "assigns the delivery_request as @delivery_request" do
        #delivery_request = create :delivery_request
        ## Trigger the behavior that occurs when invalid params are submitted
        #DeliveryRequest.any_instance.stub(:save).and_return(false)
        #put :update, {:id => delivery_request.to_param, :delivery_request => {}}
        #assigns(:delivery_request).should eq(delivery_request)
      #end

      #it "re-renders the 'edit' template" do
        #delivery_request = create :delivery_request
        ## Trigger the behavior that occurs when invalid params are submitted
        #DeliveryRequest.any_instance.stub(:save).and_return(false)
        #put :update, {:id => delivery_request.to_param, :delivery_request => {}}
        #response.should render_template("edit")
      #end
    #end
  #end

  describe "DELETE destroy" do
    it "destroys the requested delivery_request" do
      delivery_request = create :delivery_request
      expect {
        delete :destroy, {:id => delivery_request.to_param}
      }.to change(DeliveryRequest, :count).by(-1)
    end

    it "redirects to the delivery_requests list" do
      delivery_request = create :delivery_request
      delete :destroy, {:id => delivery_request.to_param}
      response.should redirect_to(delivery_requests_url)
    end
  end

end
