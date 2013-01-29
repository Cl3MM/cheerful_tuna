# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
CheerfulTuna::Application.initialize!

# ActiveRecord::Base#find shortcut
class <<ActiveRecord::Base
  alias_method :[], :find
end
