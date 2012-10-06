module ContactsHelper
  def dash_display arg
    arg.blank? ? "-" : arg
  end
  def display_website web
    if web and web.match(/http.*/i)
      www  = /\b[http:\/\/]?www\.([a-z0-9\._%-]+\.[a-z]{2,4})\b/i
      short_url = web.scan(www).flatten.first || web
      raw("<a title=\"#{h(web)}\" target=\"_blank\" href=\"#{h(web)}\">#{h(short_url.truncate(16))}</a>")
    else
      "-"
    end
  end
end
