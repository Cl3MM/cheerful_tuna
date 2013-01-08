require 'spec_helper'

describe Mailing do
  describe "Creates destinees lists" do
    it "creates to email list" do
      @too_1 = build(:contact, single_email: true, country: "Albania")
      @too_1.tag_list  = "to"
      @too_1.save
      @too_2 = build(:contact, single_email: true, country: "Albania")
      @too_2.tag_list  = "to"
      @too_2.save
      @cc  = build(:contact, single_email: true, country: "Albania")
      @cc.tag_list  = "cc"
      @cc.save
      @bcc = build(:contact, single_email: true, country: "Albania")
      @bcc.tag_list  = "bcc"
      @bcc.save
      @mailing = create(:mailing, to: "to, contact@ceres-recycle.org", cc: "cc", bcc: "bcc", send_at: 3.hours )
      puts "=" * 120
      puts "=\n=\n=\n="
      puts @too_1.email_addresses
      puts @too_2.email_addresses
      out = @mailing.prepare_destinees_before_send
      emails = []
      emails.concat(@too_1.email_addresses).concat(@too_2.email_addresses).append("contact@ceres-recycle.org").flatten
      out.should eq( { to: emails.sort!,
                    cc: [@cc.email_addresses.join(';')],
                    bcc: [@bcc.email_addresses.join(';')]
                    })

    end
  end
end
