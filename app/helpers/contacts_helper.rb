module ContactsHelper
  def dash_display arg
    arg.blank? ? "-" : arg
  end
  def display_website web
    raw("<a target=\"_blank\" href=\"#{web}\">#{web}</a>") unless web.blank? and web.match(/http.*/i)
  end
end
