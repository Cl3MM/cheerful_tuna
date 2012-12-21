require 'spec_helper'

describe "DeliveryRequests" do
  describe "GET /collection_points" do
    it "fetches more orders when scrolling to the bottom", js: true do
      11.times { |n| Order.create! number: n+1 }
      visit orders_path
      page.should have_content('Order #1')
    end
  end
end
