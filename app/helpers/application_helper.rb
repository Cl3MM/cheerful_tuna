#encoding: utf-8
module ApplicationHelper
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def contact_details model
    if model.respond_to? :contacts
      html = ["<dl>"]
      html << model.contacts.map do |c|
        "<dt>#{c.full_name}</dt>
      <dd>#{c.email_addresses.map{|e| "#{mail_to(e, e, encode:"hex")}"}.join("<br />")}</dd>"
      end
      html.delete_if{|o| o.respond_to?(:empty?) && o.empty? }
      html << "</dl>"
      html = ["<b>No contacts</b>"] if html.size == 2
      raw html.join()
    else
      Rails.logger.debug "#{Time.now.strftime("%b:%d:%Y_%H:%M:%S_")}RESCUE_INFO from application_helper: wrong parameter: #{model} | class: #{model.class} | inspect: #{model.inspect}"
      "Model has no contacts."
    end
  end

end
