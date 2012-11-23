require 'spec_helper'

describe "collection_points/show" do
  before(:each) do
    @collection_point = assign(:collection_point, stub_model(CollectionPoint,
      :cp_id => "Cp",
      :name => "Name",
      :telephone => "Telephone",
      :address => "Address",
      :postal_code => "Postal Code",
      :city => "City",
      :country => "Country"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Cp/)
    rendered.should match(/Name/)
    rendered.should match(/Telephone/)
    rendered.should match(/Address/)
    rendered.should match(/Postal Code/)
    rendered.should match(/City/)
    rendered.should match(/Country/)
  end
end
