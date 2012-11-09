require 'spec_helper'

describe "delivery_requests/show" do
  before(:each) do
    @delivery_request = assign(:delivery_request, stub_model(DeliveryRequest,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Email/)
    rendered.should match(/Telephone/)
    rendered.should match(/Address/)
    rendered.should match(/Postal Code/)
    rendered.should match(/City/)
    rendered.should match(/Longitude/)
    rendered.should match(/Latitude/)
    rendered.should match(/Country/)
    rendered.should match(/Serial Numbers/)
    rendered.should match(/Manufacturers/)
    rendered.should match(/Crystalline Silicon/)
    rendered.should match(/Amorphous Micromorph Silicon/)
    rendered.should match(/Laminates Flexible Modules/)
    rendered.should match(/Concentration Pv/)
    rendered.should match(/Cigs/)
    rendered.should match(/Cd Te/)
    rendered.should match(/Length/)
    rendered.should match(/Witdh/)
    rendered.should match(/Height/)
    rendered.should match(/Weight/)
    rendered.should match(/Reason Of Disposal/)
    rendered.should match(/Modules Condition/)
  end
end
