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

end
