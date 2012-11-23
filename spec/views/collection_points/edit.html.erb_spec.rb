require 'spec_helper'

describe "collection_points/edit" do
  before(:each) do
    @collection_point = assign(:collection_point, stub_model(CollectionPoint,
      :cp_id => "MyString",
      :name => "MyString",
      :telephone => "MyString",
      :address => "MyString",
      :postal_code => "MyString",
      :city => "MyString",
      :country => "MyString"
    ))
  end

  it "renders the edit collection_point form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => collection_points_path(@collection_point), :method => "post" do
      assert_select "input#collection_point_cp_id", :name => "collection_point[cp_id]"
      assert_select "input#collection_point_name", :name => "collection_point[name]"
      assert_select "input#collection_point_telephone", :name => "collection_point[telephone]"
      assert_select "input#collection_point_address", :name => "collection_point[address]"
      assert_select "input#collection_point_postal_code", :name => "collection_point[postal_code]"
      assert_select "input#collection_point_city", :name => "collection_point[city]"
      assert_select "input#collection_point_country", :name => "collection_point[country]"
    end
  end
end
