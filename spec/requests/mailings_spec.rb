require 'spec_helper'
include Warden::Test::Helpers

def login_as_admin
  user = create(:admin)
  login_as(user)
end

describe "Mailings" do

  describe "Create Mailing with login admin user" do
    before(:each) do
      login_as_admin
    end

    after(:each) do
      Warden.test_reset!
    end

    it "with valid params", js: true do
      2.times do
        contact           = build(:contact, single_email: true, country: "Albania")
        contact.tag_list  = "test"
        contact.save
      end
      2.times do
        contact           = build(:contact, single_email: true, country: "France")
        contact.tag_list  = "test, bob"
        contact.save
      end
      email_listing       = create(:email_listing, per_line: 70, countries: "France", tags:"test")
      email_listing.emails.count == 2
      visit       new_mailing_path
      page.should have_content "New"
      sleep 1

      select2_select "test", from: "mailing_to"
      select2_select "test", from: "mailing_cc"
      select2_select "test", from: "mailing_bcc"
      fill_in     "Subject",  with: "Super mailing"
      fill_in     "Template", with: "default"
      click_on    "Create"
      page.should have_content('success')
    end
  end
end
