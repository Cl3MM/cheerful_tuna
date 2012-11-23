require 'spec_helper'

describe "collection_points/index" do
  before(:each) do
    assign(:collection_points, [
      stub_model(CollectionPoint,
        :cp_id => "Cp",
        :name => "Name",
        :telephone => "Telephone",
        :address => "Address",
        :postal_code => "Postal Code",
        :city => "City",
        :country => "Country"
      ),
      stub_model(CollectionPoint,
        :cp_id => "Cp",
        :name => "Name",
        :telephone => "Telephone",
        :address => "Address",
        :postal_code => "Postal Code",
        :city => "City",
        :country => "Country"
      )
    ])
  end

  it "renders a list of collection_points" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Cp".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Telephone".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "Postal Code".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "Country".to_s, :count => 2
  end
end
