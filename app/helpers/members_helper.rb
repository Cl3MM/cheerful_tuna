#encoding: utf-8
module MembersHelper
  def prettify date
    date.strftime("%B %d, %Y")
  end

  def tooltip contact
    html = ["Company: #{h(contact.company.upcase)}"]
    html << "Email: #{contact.email_addresses.map{|e| "#{mail_to(e, e, encode:"hex")}"}.join(", ")}"
    h html.join("<br />")
  end
  def contact_details member
    html = ["<dl>"]
    html << member.contacts.map do |c|
      "<dt>#{c.full_name}</dt>
      <dd>#{c.email_addresses.map{|e| "#{mail_to(e, e, encode:"hex")}"}.join("<br />")}</dd>"
    end
    html << "</dl>"
    raw html.join()
  end

  def display_address member
    html = <<HTML
<address>
  <strong>#{h(member.company.upcase)}</strong><br>
  #{(member.address.blank? ? link_to("Please set the Address", edit_member_path(member)) : h(member.address)) }<br>
  #{(member.postal_code.blank? ? link_to("Please set the Postal Code", edit_member_path(member)) : member.postal_code ) }, 
  #{(member.city.blank? ? link_to("Please set the City", edit_member_path(member)) : member.city ) }<br>
  #{member.country.upcase}<br>
</address>
HTML
  raw html
  end
  def membership_details member
    html = <<HTML
<dl class="dl-horizontal">
  <dt>Start date:</dt><dd class="link_color">#{prettify @member.start_date}</dd>
  <dt>End date:</dt><dd class="link_color">#{prettify @member.end_date}</dd>
  <dt>Category:</dt><dd>#{member.category} - #{h(member.category_price)}</dd>
  <dt>Activity:</dt><dd>#{(member.activity.blank? ? link_to("Please set the Activity", edit_member_path(member)) : h(member.activity)) }</dd>
  <dt>Web:</dt><dd>#{member.web_profile_url}</dd>
  <dt>Username:</dt><dd>#{member.user_name}</dd>
</dl>
HTML
  raw html
  end

end
