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

  def render_navbar_header
    member_section = ["/login", "/members/confirmation"]
    if member_section.include? request.env['PATH_INFO']
      raw '<a class="brand" href="#">CERES Members area</a>' unless current_user
    elsif  request.env['PATH_INFO'] == "/users/login"
      raw '<a class="brand" href="#"><i class="icon-fire"></i> Über contact database <i class="icon-fire"></i></a>' # unless current_member
    #else
      #raw '<a class="brand" href="#">COUCOU</a>' unless current_user and current_member
    end
  end
end
