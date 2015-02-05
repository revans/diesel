require 'rails/generators'
require_relative '../../diesel/actions'

module Diesel
  module Generators
    class AuthGenerator < ::Rails::Generators::Base
      include ::Diesel::Actions

      desc "Login/Logout Stuff"

      source_root ::File.expand_path("../templates", __FILE__)
      class_option :template_engine

      def initialize(args = [], options = {}, config = {})
        super(args, options, config)
      end

      def create_auth_folders
        log :create_auth_folders, ""
        in_root do
          mkdir_p "app/views/sessions"
          mkdir_p "app/views/users"
          mkdir_p "test/support"
        end
      end

      def generate_auth_model
        log :generate_auth_model, ""
        generate :model, "user",  "first_name:string",
                                  "last_name:string",
                                  "email:string:index",
                                  "password_digest:string"

        inject_into_file 'app/models/user.rb',
        "  has_secure_password\n",
        after: "class User < ActiveRecord::Base\n"
      end


      def copy_auth_files
        log :copy_auth_files, ""
        # Controllers
        copy_file "controllers/sessions_controller.rb",  "app/controllers/sessions_controller.rb"
        copy_file "controllers/users_controller.rb",     "app/controllers/users_controller.rb"

        # Views
        copy_file "views/sessions_new.html.erb",    "app/views/sessions/new.html.erb"
        copy_file "views/users_edit.html.erb",      "app/views/users/edit.html.erb"
        copy_file "views/users_show.json.jbuilder", "app/views/users/show.json.jbuilder"

        # Concerns
        copy_file "controllers/session_authentication.rb",
            'app/controllers/concerns/session_authentication.rb'

        copy_file "controllers/api_authentication.rb",
            'app/controllers/concerns/api_authentication.rb'

        copy_file "controllers/api_versioning.rb",
            'app/controllers/concerns/api_versioning.rb'

        # Tests
        copy_file "test/session_auth_test_helper.rb",
                  'test/support/session_auth_test_helper.rb'

        copy_file "test/api_helper.rb",
                  'test/support/api_helper.rb'

        copy_file "test/authorization_helper.rb",
                  'test/support/authorization_helper.rb'

        # Test Helper
        inject_into_file 'test/test_helper.rb',
            "Dir[Rails.root.join('test/support/**/*.rb')].each { |file| require file }\n",
            after: "require 'rails/test_help'\n"

        inject_into_file 'test/test_helper.rb',
            "\nclass ActionController::TestCase\n  include ::SessionAuthTestHelper, ::ApiHelper\nend",
            after: "end\n"

        copy_file "test/models/user_test.rb",
                  "test/models/user_test.rb"

        copy_file "test/controllers/sessions_controller_test.rb",
                  "test/controllers/sessions_controller_test.rb"

        copy_file "test/controllers/users_controller_test.rb",
                  "test/controllers/users_controller_test.rb"

        copy_file "test/controllers/sessions_api_test.rb",
                  "test/controllers/sessions_api_test.rb"

        copy_file "test/controllers/users_api_test.rb",
                  "test/controllers/users_api_test.rb"

        copy_file "test/fixtures/users.yml",
                  "test/fixtures/users.yml", force: true

        copy_file "config/api.yml", "config/api.yml"
      end

      def add_auth_routes
        log :add_auth_routes, ""
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
        log :filter_password_confirmation, ""
        replace_in_file 'config/initializers/filter_parameter_logging.rb',
            'Rails.application.config.filter_parameters += [:password]',
            'Rails.application.config.filter_parameters += [:password, :password_confirmation]'
      end


      # def create_login_template
      #   log :create_login_template, ""
      #   copy_file "views/login_layout.html.erb",
      #             'app/views/layouts/login.html.erb'


      #   mkdir_p "app/views/application"
      #   touch "app/views/application/_doctype.html.erb"
      #   touch "app/views/application/_nav.html.erb"
      #   touch "app/views/application/_flashes.html.erb"
      #   touch "app/views/application/_footer.html.erb"
      # end


      def include_session_auth_concern
        log :include_session_auth_concern, ""
        content = <<-EOF
  include SessionAuthentication,
          ApiAuthentication,
          ApiVersioning

  def json_requested?
    request.format.json?
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = "Token realm='\#{api_config['company_name']}'"
    render json: 'Bad credentials', status: 401
  end

  private

  def api_config
    ::Rails.application.config_for(:api)
  end
        EOF

        insert_into_file("app/controllers/application_controller.rb",
                         content,
                         after: "protect_from_forgery with: :exception\n\n")
      end

      def copy_locale
        log :copy_locale, ""
        copy_file "config/locales/login.en.yml", "config/locales/login.en.yml"
      end

      def add_bcrypt_gem
        log :add_bcrypt_gem, ""
        gem 'bcrypt'
      end

      def execute_bundle_install
        log :execute_bundle_install, ""
        in_root { run "bundle" }
      end


    end
  end
end
