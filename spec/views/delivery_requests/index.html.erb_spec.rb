require 'spec_helper'

describe "delivery_requests/index" do
  before(:each) do
    assign(:delivery_requests, [
      stub_model(DeliveryRequest,
        :name => "Name",
        :email => "Email",
        :telephone => "Telephone",
        :address => "Address",
        :postal_code => "Postal Code",
        :city => "City",
        :longitude => "Longitude",
        :latitude => "Latitude",
        :country => "Country",
        :serial_numbers => "Serial Numbers",
        :manufacturers => "Manufacturers",
        :crystalline_silicon => "Crystalline Silicon",
        :amorphous_micromorph_silicon => "Amorphous Micromorph Silicon",
        :laminates_flexible_modules => "Laminates Flexible Modules",
        :concentration_PV => "Concentration Pv",
        :CIGS => "Cigs",
        :CdTe => "Cd Te",
        :length => "Length",
        :witdh => "Witdh",
        :height => "Height",
        :weight => "Weight",
        :reason_of_disposal => "Reason Of Disposal",
        :modules_condition => "Modules Condition"
      ),
      stub_model(DeliveryRequest,
        :name => "Name",
        :email => "Email",
        :telephone => "Telephone",
        :address => "Address",
        :postal_code => "Postal Code",
        :city => "City",
        :longitude => "Longitude",
        :latitude => "Latitude",
        :country => "Country",
        :serial_numbers => "Serial Numbers",
        :manufacturers => "Manufacturers",
        :crystalline_silicon => "Crystalline Silicon",
        :amorphous_micromorph_silicon => "Amorphous Micromorph Silicon",
        :laminates_flexible_modules => "Laminates Flexible Modules",
        :concentration_PV => "Concentration Pv",
        :CIGS => "Cigs",
        :CdTe => "Cd Te",
        :length => "Length",
        :witdh => "Witdh",
        :height => "Height",
        :weight => "Weight",
        :reason_of_disposal => "Reason Of Disposal",
        :modules_condition => "Modules Condition"
      )
    ])
  end

  it "renders a list of delivery_requests" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Telephone".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "Postal Code".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "Longitude".to_s, :count => 2
    assert_select "tr>td", :text => "Latitude".to_s, :count => 2
    assert_select "tr>td", :text => "Country".to_s, :count => 2
    assert_select "tr>td", :text => "Serial Numbers".to_s, :count => 2
    assert_select "tr>td", :text => "Manufacturers".to_s, :count => 2
    assert_select "tr>td", :text => "Crystalline Silicon".to_s, :count => 2
    assert_select "tr>td", :text => "Amorphous Micromorph Silicon".to_s, :count => 2
    assert_select "tr>td", :text => "Laminates Flexible Modules".to_s, :count => 2
    assert_select "tr>td", :text => "Concentration Pv".to_s, :count => 2
    assert_select "tr>td", :text => "Cigs".to_s, :count => 2
    assert_select "tr>td", :text => "Cd Te".to_s, :count => 2
    assert_select "tr>td", :text => "Length".to_s, :count => 2
    assert_select "tr>td", :text => "Witdh".to_s, :count => 2
    assert_select "tr>td", :text => "Height".to_s, :count => 2
    assert_select "tr>td", :text => "Weight".to_s, :count => 2
    assert_select "tr>td", :text => "Reason Of Disposal".to_s, :count => 2
    assert_select "tr>td", :text => "Modules Condition".to_s, :count => 2
  end
end
