# Load the rails application
require File.expand_path('../application', __FILE__)

TUNA_CONFIG = YAML.load_file("#{Rails.root}/config/tuna.yml")[Rails.env]
# Initialize the rails application
CheerfulTuna::Application.initialize!
