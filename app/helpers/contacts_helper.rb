module ContactsHelper
  def dash_display arg
    arg.blank? ? "-" : arg
  end
end
