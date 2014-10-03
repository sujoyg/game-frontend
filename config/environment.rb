# Load the rails application
require File.expand_path('../application', __FILE__)

I18n.enforce_available_locales = true

# Initialize the rails application
Product::Application.initialize!
