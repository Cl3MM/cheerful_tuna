require 'spec_helper'
require 'awesome_print'

describe "DeliveryRequests", focus: true do
  before(:each) do
    @html_snippet = create :html_snippet
  end

  describe "create new delivery request form" do

    it "with valid parameters" do
      dlvrq = build(:delivery_request)
      ap dlvrq
      visit new_delivery_request_url

      fill_in "Contact name",       with: dlvrq.name
      fill_in "Email",              with: dlvrq.email
      fill_in "Address",            with: dlvrq.address
      fill_in "Postal code",        with: dlvrq.postal_code
      fill_in "City",               with: dlvrq.city
      fill_in "Number of modules",  with: dlvrq.module_count
      fill_in "Number of pallets",  with: dlvrq.pallets_number
      fill_in "Length",             with: dlvrq.length
      fill_in "Width",              with: dlvrq.width
      fill_in "Height",             with: dlvrq.height
      fill_in "Weight",             with: dlvrq.weight
      select  dlvrq.country,            from: "Country"
      select  dlvrq.reason_of_disposal, from: "Reason of disposal"
      select  dlvrq.modules_condition,  from: "Modules condition"
      #choose  DLV_RQST_TECHNOS[dlvrq.technology].downcase
      choose  "delivery_request_technology_cdte"

      click_button "Send Delivery request"
      page.should have_content("Delivery Request summary")
      page.should have_content("success")
    end
  end
end
