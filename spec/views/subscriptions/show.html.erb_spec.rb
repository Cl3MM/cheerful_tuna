require 'spec_helper'

describe "subscriptions/show" do
  before(:each) do
    @subscription = assign(:subscription, stub_model(Subscription,
      :owner_id => 1,
      :current => false,
      :cost => "9.99",
      :paid => false,
      :status => "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/false/)
    rendered.should match(/9.99/)
    rendered.should match(/false/)
    rendered.should match(/Status/)
  end
end
