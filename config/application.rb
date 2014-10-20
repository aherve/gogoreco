require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_view/railtie"
 require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Gogoreco
  class Application < Rails::Application
    config.to_prepare do 
      DeviseController.respond_to :json
    end
    #config.middleware.use Rack::Cors do 
    #  allow do 
    #    #origins 'localhost:8100','shapter.com','137.194.15.150'
    #    origins '*'
    #    resource '*', :headers => :any, :methods => [:get, :post, :options, :delete, :put]
    #  end
    #end
  end
end
