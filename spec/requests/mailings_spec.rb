require 'spec_helper'
include Warden::Test::Helpers

def login_as_admin
  user = create(:admin)
  login_as(user)
end
describe "Mailings", focus: true do

  describe "Create Mailing with login admin user" do
    before(:each) do
      login_as_admin
    end

    after(:each) do
      Warden.test_reset!
    end

    it "with valid params" do
      2.times do
        contact           = build(:contact, country: "Albania")
        contact.tag_list  = "test"
        contact.save
      end
      2.times do
        contact           = build(:contact, country: "France")
        contact.tag_list  = "test, bob"
        contact.save
      end
      email_listing       = create(:email_listing, per_line: 70, countries: "France", tags:"test")
      puts email_listing.find_emails
      puts email_listing.find_emails.count
      email_listing.find_emails.count should eq(2)
      visit       new_mailing_path
      page.should have_content "New"
      fill_in     "Subject",  with: "Super mailing"
      fill_in     "Template",   with: "default"
      click_on    "Create"
      page.should have_content('success')
    end
  end
end
