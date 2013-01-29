require 'spec_helper'

describe "subscriptions/index" do
  before(:each) do
    assign(:subscriptions, [
      stub_model(Subscription,
        :owner_id => 1,
        :current => false,
        :cost => "9.99",
        :paid => false,
        :status => "Status"
      ),
      stub_model(Subscription,
        :owner_id => 1,
        :current => false,
        :cost => "9.99",
        :paid => false,
        :status => "Status"
      )
    ])
  end

  it "renders a list of subscriptions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
  end
end
