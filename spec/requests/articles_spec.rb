require 'spec_helper'
include Warden::Test::Helpers

def login_as_admin
  user = create(:admin)
  login_as(user)
end
describe "Articles" do

  describe "Create Article with login admin user" do
    before(:each) do
      login_as_admin
    end

    after(:each) do
      Warden.test_reset!
    end

    it "with valid params" do
      visit       new_article_path
      page.should have_content "New"
      fill_in     "Title",  with: "Super article"
      fill_in     "Content",   with: "<div class=\"well\"><p>Super content</p></div>"
      click_on    "Create"
      page.should have_content('success')
    end
    it "with blank params" do
      visit       new_article_path
      page.should have_content "New"
      fill_in     "Title",  with: ""
      click_on    "Create"
      page.should have_content("Content can't be blank")
      page.should have_content("Title can't be blank")
    end
    it "throws error when creating duplicate content" do
      visit       new_article_path
      page.should have_content "New"
      fill_in     "Title",  with: "same same"
      fill_in     "Content",  with: "same same"
      click_on    "Create"
      page.should have_content('success')
      visit       new_article_path
      page.should have_content "New"
      fill_in     "Title",  with: "same same"
      fill_in     "Content",  with: "same same"
      click_on    "Create"
      page.should have_content("Content has already been taken")
      page.should have_content("Title has already been taken")
    end
  end
end
