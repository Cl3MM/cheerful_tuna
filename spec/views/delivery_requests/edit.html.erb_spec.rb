require 'spec_helper'

describe "delivery_requests/edit" do
  before(:each) do
    @delivery_request = assign(:delivery_request, stub_model(DeliveryRequest,
      :name => "MyString",
      :email => "MyString",
      :telephone => "MyString",
      :address => "MyString",
      :postal_code => "MyString",
      :city => "MyString",
      :longitude => "MyString",
      :latitude => "MyString",
      :country => "MyString",
      :serial_numbers => "MyString",
      :manufacturers => "MyString",
      :crystalline_silicon => "MyString",
      :amorphous_micromorph_silicon => "MyString",
      :laminates_flexible_modules => "MyString",
      :concentration_PV => "MyString",
      :CIGS => "MyString",
      :CdTe => "MyString",
      :length => "MyString",
      :witdh => "MyString",
      :height => "MyString",
      :weight => "MyString",
      :reason_of_disposal => "MyString",
      :modules_condition => "MyString"
    ))
  end

  it "renders the edit delivery_request form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => delivery_requests_path(@delivery_request), :method => "post" do
      assert_select "input#delivery_request_name", :name => "delivery_request[name]"
      assert_select "input#delivery_request_email", :name => "delivery_request[email]"
      assert_select "input#delivery_request_telephone", :name => "delivery_request[telephone]"
      assert_select "input#delivery_request_address", :name => "delivery_request[address]"
      assert_select "input#delivery_request_postal_code", :name => "delivery_request[postal_code]"
      assert_select "input#delivery_request_city", :name => "delivery_request[city]"
      assert_select "input#delivery_request_longitude", :name => "delivery_request[longitude]"
      assert_select "input#delivery_request_latitude", :name => "delivery_request[latitude]"
      assert_select "input#delivery_request_country", :name => "delivery_request[country]"
      assert_select "input#delivery_request_serial_numbers", :name => "delivery_request[serial_numbers]"
      assert_select "input#delivery_request_manufacturers", :name => "delivery_request[manufacturers]"
      assert_select "input#delivery_request_crystalline_silicon", :name => "delivery_request[crystalline_silicon]"
      assert_select "input#delivery_request_amorphous_micromorph_silicon", :name => "delivery_request[amorphous_micromorph_silicon]"
      assert_select "input#delivery_request_laminates_flexible_modules", :name => "delivery_request[laminates_flexible_modules]"
      assert_select "input#delivery_request_concentration_PV", :name => "delivery_request[concentration_PV]"
      assert_select "input#delivery_request_CIGS", :name => "delivery_request[CIGS]"
      assert_select "input#delivery_request_CdTe", :name => "delivery_request[CdTe]"
      assert_select "input#delivery_request_length", :name => "delivery_request[length]"
      assert_select "input#delivery_request_witdh", :name => "delivery_request[witdh]"
      assert_select "input#delivery_request_height", :name => "delivery_request[height]"
      assert_select "input#delivery_request_weight", :name => "delivery_request[weight]"
      assert_select "input#delivery_request_reason_of_disposal", :name => "delivery_request[reason_of_disposal]"
      assert_select "input#delivery_request_modules_condition", :name => "delivery_request[modules_condition]"
    end
  end
end
