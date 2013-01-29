require 'spec_helper'

describe "subscriptions/new" do
  before(:each) do
    assign(:subscription, stub_model(Subscription,
      :owner_id => 1,
      :current => false,
      :cost => "9.99",
      :paid => false,
      :status => "MyString"
    ).as_new_record)
  end

  it "renders new subscription form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => subscriptions_path, :method => "post" do
      assert_select "input#subscription_owner_id", :name => "subscription[owner_id]"
      assert_select "input#subscription_current", :name => "subscription[current]"
      assert_select "input#subscription_cost", :name => "subscription[cost]"
      assert_select "input#subscription_paid", :name => "subscription[paid]"
      assert_select "input#subscription_status", :name => "subscription[status]"
    end
  end
end
