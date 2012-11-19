#encoding: utf-8
module MembersHelper
  def format_date date, short = false
    date.strftime("#{short ? "%a" : "%B"} #{date.day.ordinalize}, %Y")
  end

  # create a select collection
  def select_per_page opts={}
    opts = { html_input: {class: "span2", id: "super_select"},
             selected: false, select_options: %w"5 10 20 50 100 250"
    }.merge(opts)
    attr = opts[:html_input].reduce([]){ |o, (k, v)| o << "#{k}=#{v}" }.join(" ") if opts[:html_input].present?
    html = ["<select #{attr if attr}>"]
    html<< opts[:select_options].map do |val|
      "<option value=\"#{val}\" #{" selected=\"selected\"" if val == opts[:selected] }>#{val}</option>"
    end
    html << ["</select>"]
    raw html.join()
  end
  def link_to_company member
    opts = {class: "a-tooltip", title: "#{h(member.company.capitalize)}"} if member.company.size > 25
    link_to(member.company.truncate(25), member_path(member), opts)
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

  def display_joomla_address member
    html = <<HTML
<address>
  <strong>#{h(member.company.upcase)}</strong><br>
  #{(member.address.blank? ? "No address" : h(member.address)) }<br>
  #{(member.postal_code.blank? ? "No postal code" : member.postal_code ) },
  #{(member.city.blank? ? "No city" : member.city ) }<br>
  #{member.country.upcase}<br>
</address>
HTML
  raw html
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
  <dt>Start date:</dt><dd class="link_color">#{format_date @member.start_date}</dd>
  <dt>End date:</dt><dd class="link_color">#{format_date @member.end_date}</dd>
  <dt>Category:</dt><dd>#{member.category} #{member.category == "Free" ? " " : "- #{member.category_price}"}</dd>
  <dt>Activity:</dt><dd>#{(member.activity_list.empty? ? link_to("Please set the Activities", edit_member_path(member)) : member.activity_list.map{|act| "<span class=\"link_color\">#{h(act.capitalize)}</span>"}.join(", ") ) }</dd>
  <dt>Brands</dt><dd>#{(member.brand_list.empty? ? link_to("Please set the Brands", edit_member_path(member)) : member.brand_list.map{|act| "<span class=\"link_color\">#{h(act.capitalize)}</span>"}.join(", ") ) }</dd>
  <dt>Web:</dt><dd>#{member.web_profile_url}</dd>
  <dt>Username:</dt><dd>#{member.user_name}</dd>
</dl>
HTML
  raw html
  end

  def joomla_membership_details member
    html = <<HTML
<div class="row-fluid">
  <div class="span2">
    <div class="right">
      <span><b>Start date:</b></span><br />
      <b>End date:</b><br />
      <b>Category:</b><br />
      <b>Activity:</b><br />
      <b>Brands:</b><br />
      <b>Web:</b><br />
      <b>Username:</b>
    </div>
  </div>
  <div class="span4">
    <span class="link-color">#{format_date @member.start_date}</span><br />
    <span class="link-color">#{format_date @member.end_date}</span><br />
    <span>#{member.category} #{member.category == "Free" ? " " : "- #{member.category_price}"}</span><br />
    <span>#{(member.activity_list.empty? ? "No activity" : member.activity_list.map{|act| "<span class=\"link_color\">#{h(act.capitalize)}</span>"}.join(", ") ) }</span><br />
    <span>#{(member.brand_list.empty? ? "No brand" : member.brand_list.map{|act| "<span class=\"link_color\">#{h(act.capitalize)}</span>"}.join(", ") ) }</span><br />
    <span>#{member.web_profile_url}</span><br />
    <span>#{member.user_name}</span>
  </div>
</div>

<div class="row-fluid">
  <div class="span5">
  <dl class="dl-horizontal">
    <dt>Start date:</dt><dd class="link_color">#{format_date @member.start_date}</dd>
    <dt>End date:</dt><dd class="link_color">#{format_date @member.end_date}</dd>
    <dt>Category:</dt><dd>#{member.category} #{member.category == "Free" ? " " : "- #{member.category_price}"}</dd>
    <dt>Activity:</dt><dd>#{(member.activity_list.empty? ? "No activity" : member.activity_list.map{|act| "<span class=\"link_color\">#{h(act.capitalize)}</span>"}.join(", ") ) }</dd>
    <dt>Brands</dt><dd>#{(member.brand_list.empty? ? "No brand" : member.brand_list.map{|act| "<span class=\"link_color\">#{h(act.capitalize)}</span>"}.join(", ") ) }</dd>
    <dt>Web:</dt><dd>#{member.web_profile_url}</dd>
    <dt>Username:</dt><dd>#{member.user_name}</dd>
  </dl>
</div>
HTML
  raw html
  end

end
