require 'diesel/version'
require 'diesel/actions'
require 'rails'

require 'generators/admin/install_generator'
require 'generators/angular/install_generator'
require 'generators/api/install_generator'
require 'generators/app_server/install_generator'
require 'generators/auth/install_generator'
require 'generators/frontend/install_generator'
require 'generators/geo/install_generator'
require 'generators/mail_sandbox/install_generator'
require 'generators/rails_gem/install_generator'
require 'generators/registration/install_generator'
require 'generators/bootstrap/install_generator'
require 'generators/bower/install_generator'

module Diesel
  module Generators
    class Engine < ::Rails::Engine
      # config.app_generators.assets = false
    end
  end
end
