require "letter_opener"
ActionMailer::Base.add_delivery_method :letter_opener, LetterOpener::DeliveryMethod, :location => File.expand_path("#{Rails.root}/tmp/letter_opener", __FILE__)
ActionMailer::Base.delivery_method = :letter_opener

describe MemberMailer do

  it "Email members", focus: true do
    create(:member, single_email: true)
    Member.all.each do |member|
      Rails.logger.debug "*"*10 + " Sending email !!!!" + "*"*10
      Rails.logger.debug "Member count: #{Member.count}"
      puts "Member count: #{Member.count}"
      @contacts = member.contacts
      Rails.logger.debug "Member's contacts count: #{member.contacts.count}"
      puts "Member's contacts count: #{@contacts.count}"

      Rails.logger.debug "Sending email to: #{member.id} | #{member.company}"
      @contacts.each do |contact|
        contact.email_addresses.each do |email|
          MemberMailer.newswire(contact.full_name, email).deliver()
        end
      end
    end

  end

  it "Geolocate user" do
  end
  #it "does not authenticate with incorrect password" do
    #create(:user, username: "batman", password: "secret")
    #User.authenticate("batman", "incorrect").should be_nil
  #end

  #it "can manage articles he owns" do
    #article = build(:article)
    #user = article.user
    #user.can_manage_article?(article).should be_true
    #user.can_manage_article?(Article.new).should be_false
  #end

  #it "can manage any articles as admin" do
    #build(:admin).can_manage_article?(Article.new).should be_true
    #build(:user).can_manage_article?(Article.new).should be_false
  #end
end
