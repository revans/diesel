require 'rails/generators'
require_relative '../../featurette/actions'

module Featurette
  module Auth
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        include ::Featurette::Actions

        desc "Login/Logout Stuff"

        source_root ::File.expand_path("../templates", __FILE__)
        class_option :template_engine

        def initialize(args = [], options = {}, config = {})
          super(args, options, config)
        end

        def create_auth_folders
          in_root do
            mkdir_p "app/views/sessions"
            mkdir_p "app/views/users"
            mkdir_p "test/support"
          end
        end

        def generate_auth_model
          generate :model, "user", "name:string", "email:string", "password_digest:string", "accept_terms:boolean"
          inject_into_file 'app/models/user.rb', "  has_secure_password\n  validates_acceptance_of :accept_terms, accept: true\n", after: "class User < ActiveRecord::Base\n"
        end


        def copy_auth_files
          # Controllers
          copy_file "controllers/sessions_controller.rb",  "app/controllers/sessions_controller.rb"
          copy_file "controllers/users_controller.rb",     "app/controllers/users_controller.rb"

          # Views
          copy_file "views/sessions_new.html.erb",   "app/views/sessions/new.html.erb"
          copy_file "views/users_edit.html.erb",     "app/views/users/edit.html.erb"

          copy_file "controllers/session_authentication.rb",
              'app/controllers/concerns/session_authentication.rb'

          # Tests
          copy_file "test/session_auth_test_helper.rb",
                    'test/support/session_auth_test_helper.rb'

          inject_into_file 'test/test_helper.rb',
              "require_relative 'support/session_auth_test_helper'\n",
              after: "require 'rails/test_help'\n"

          inject_into_file 'test/test_helper.rb',
              "class ActionController::TestCase\n  include ::SessionAuthTestHelper\nend",
              after: "end\n"

          copy_file "test/models/user_test.rb",
                    "test/models/user_test.rb"

          copy_file "test/controllers/sessions_controller_test.rb",
                    "test/controllers/sessions_controller_test.rb"

          copy_file "test/controllers/users_controller_test.rb",
                    "test/controllers/users_controller_test.rb"

          copy_file "test/fixtures/users.yml",
                    "test/fixtures/users.yml", force: true
        end

        def add_auth_routes
          auth_routes = <<-ROUTE

  # User Resource
  resources :users

  # Login & Logout
  delete  "/logout",      to: "sessions#destroy",       as: :logout
  post    "/login",       to: "sessions#create",        as: :perform_login
  get     "/login",       to: "sessions#new",           as: :login

  # Default Route should go to the login page
  root "sessions#new"

          ROUTE

          route auth_routes
        end

        # Adds password_confirmation to the filtered parameters array
        def filter_password_confirmation
          replace_in_file 'config/initializers/filter_parameter_logging.rb',
              'Rails.application.config.filter_parameters += [:password]',
              'Rails.application.config.filter_parameters += [:password, :password_confirmation]'
        end


        def create_login_template
          copy_file "views/login_layout.html.erb",
                    'app/views/layouts/login.html.erb'
        end


        def include_session_auth_concern
          content = "  include SessionAuthentication"
          insert_into_file("app/controllers/application_controller.rb", content, after: "class ApplicationController < ActionController::Base\n\n")
        end

        def copy_locale
          copy_file "config/locales/login.en.yml", "config/locales/login.en.yml"
        end

        def add_bcrypt_gem
          gem 'bcrypt'
        end

        def execute_bundle_install
          log :execute_bundle_install, ""
          in_root { run "bundle" }
        end


      end
    end
  end
end
