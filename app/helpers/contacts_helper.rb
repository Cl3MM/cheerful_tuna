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
    #if web.blank?
      #str = "-"
    #end
    #if web.blank? or not web.match(/http.*/i)
      ##str = raw("<a target=\"_blank\" href=\"#{web}\">#{web}</a>")
    ##end
    #str
  end
end
