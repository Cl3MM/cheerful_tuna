Tire.configure do
  logger Rails.root + "log/tire_#{Rails.env}.log"
end

Contact.create_search_index unless Contact.search_index.exists?
