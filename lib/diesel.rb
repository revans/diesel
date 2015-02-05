require 'diesel/version'
require 'diesel/actions'
require 'rails'

require 'generators/auth/auth_generator'
require 'generators/registration/register_generator'
require 'generators/mail_sandbox/mail_generator'
require 'generators/app_server/server_generator'
require 'generators/bower/bower_generator'
require 'generators/geo/geo_generator'
require 'generators/admin/admin_generator'



require 'generators/angular/install_generator'
require 'generators/rails_gem/install_generator'
require 'generators/bootstrap/install_generator'


# require 'generators/api/install_generator'
# require 'generators/frontend/install_generator'


module Diesel
  module Generators
    class Engine < ::Rails::Engine
      # config.app_generators.assets = false
    end
  end
end
