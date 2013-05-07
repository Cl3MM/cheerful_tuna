describe "Members Subscriptions" do

  it "Can't have several equal start_date" do
    member = create(:member)
    member.subscriptions.create( start_date: Date.parse("01/01/2012") )
    Subscription.count.should eq(1)
    member.subscriptions.create( start_date: Date.parse("01/01/2012") )
  end

  it "Preview renewal mailing" do
    MemberMailer.membership_2013_renewal( "Clement Roullet", "clement.roullet@gmail.com").deliver
  end

end
