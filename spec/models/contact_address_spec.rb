describe Contact do
  it "creates contact" do
    @contact  = create(:contact_with_emails)
    puts "contact: {id: #{@contact.id}, name: #{@contact.full_name}}"
    puts "contact emails: #{@contact.email_addresses}"
    puts "Email size: #{@contact.emails.size}"
    puts "Emails count: #{Email.count}"
    puts "Emails:\n#{Email.all.map{|e| "{id: #{e.id}, address: #{e.address}, contact_id: #{e.contact_id}}"}.join("\n")}"
    puts "Contacts count: #{Contact.count}"
    puts "Email contact: #{Email.first.contact.company}"

    puts "Email for contact id: #{@contact.id}\n#{Email.find_all_by_contact_id(@contact.id).map(&:address).join("\n")}"
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
