class EmailListing < ActiveRecord::Base
  attr_accessible :name, :per_line, :countries

  def countries_to_sql
    countries.split(";").map{|m| "'#{m}'"}.join(",")
  end
end
