module ContactsHelper
  def dash_display arg
    arg.blank? ? "-" : arg
  end
  def display_website web
    if web and web.match(/http.*/i)
      raw("<a title=\"#{web}\" target=\"_blank\" href=\"#{web}\">[URL]</a>")
    else
      "-"
    end
  end
end
