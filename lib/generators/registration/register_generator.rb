require 'rails/generators'
require_relative '../../diesel/actions'

module Diesel
  module Generators
    class RegisterGenerator < ::Rails::Generators::Base
      include ::Diesel::Actions

      desc "User Registration System"

      source_root ::File.expand_path("../templates", __FILE__)
      class_option :template_engine

      def initialize(args = [], options = {}, config = {})
        super(args, options, config)
      end

      def create_reg_folders
        # Create View Folders
        in_root do
          mkdir_p "app/views/registrations"
          mkdir_p "app/views/dashboard"
        end
      end

      def copy_reg_files
        # Controllers
        copy_file "controllers/registrations_controller.rb",  "app/controllers/registrations_controller.rb"
        copy_file "controllers/dashboard_controller.rb",      "app/controllers/dashboard_controller.rb"

        # Views
        copy_file "views/registrations_new.html.erb",   "app/views/registrations/new.html.erb"
        copy_file "views/dashboard_index.html.erb",     "app/views/dashboard/index.html.erb"

        # Tests
        copy_file "test/controllers/dashboard_controller_test.rb",
                  "test/controllers/dashboard_controller_test.rb"

        copy_file "test/controllers/registrations_controller_test.rb",
                  "test/controllers/registrations_controller_test.rb"

         copy_file "test/controllers/registrations_api_test.rb",
                  "test/controllers/registrations_api_test.rb"
      end

      def add_reg_routes
        reg_routes = <<-ROUTE

  # regisration
  get     "/register",    to: "registrations#new",      as: :registration
  post    "/register",    to: "registrations#create",   as: :create_registration

  # dashboard
  get     "/dashboard",   to: "dashboard#index",        as: :dashboard
        ROUTE

        route reg_routes
      end

    end
  end

end
