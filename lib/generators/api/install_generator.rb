require 'rails/generators'
require_relative '../../diesel/actions'

module Diesel
  module Api
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        include ::Diesel::Actions

        desc "Api Building Foundation"

        source_root ::File.expand_path("../templates", __FILE__)
        class_option :template_engine

        def initialize(args = [], options = {}, config = {})
          super(args, options, config)
        end

        def add_testing_api_gem
          log :add_testing_api_gem, ""

          gem_group :development, :test do
            gem 'gorillapi', github: 'revans/gorillapi'
          end
        end

        def copy_api_constraints_library
          log :copy_api_constraints_library, ""

          copy_file "lib/api_constraints.rb",
                    'lib/api_constraints.rb'
        end

        def add_api_constraints_to_routes
          log :add_api_constraints_to_routes, ""

          insert_into_file('config/routes.rb', "require Rails.root.join('lib/api_constraints')\n\n", before: "Rails.application.routes.draw do\n")
        end

        def add_api_route_namespace
          log :add_api_route_namespace, ""

          api_namespace = <<-NAMESPACE

  namespace :api, defaults: { format: 'json' } do
    namespace :v1, constraints: PrivateApiConstraints.new(version: ::Rails.application.config_for(:api).version, default: true) do

    end
  end

          NAMESPACE

          route api_namespace
        end


        def copy_disable_xml_params
          log :copy_disable_xml_params, ""

          copy_file "initializers/disable_xml_params.rb",
                    'config/initializers/disable_xml_params.rb'
        end

        def copy_api_test_rake_tasks
          log :copy_api_test_rake_tasks, ""

          copy_file "tasks/api.rake",
                    'lib/tasks/api.rake'
        end

        def copy_api_controllers
          log :copy_api_controllers, ""

          mkdir_p   "app/controllers/api/v1"

          copy_file "controllers/api_controller.rb",
                    'app/controllers/api/v1/api_controller.rb'

          copy_file "controllers/ping_controller.rb",
                    'app/controllers/api/v1/ping_controller.rb'
        end


        def copy_api_test_helpers
          log :copy_api_test_helpers, ""

          mkdir_p 'test/support'

          copy_file "test/api_auth_test_helper.rb",
                    'test/support/api_auth_test_helper.rb'
        end

        def copy_api_docs_starterkit
          log :copy_api_docs_starterkit, ""

          mkdir_p   "doc"

          template  "doc/api_doc.mkd.erb",
                    'doc/api.mkd',
                    force: true
        end


        def copy_api_config
          log :copy_api_config, ""

          copy "config/api.yml",  "config/api.yml"
          copy "lib/api_test.rb", "lib/api_test.rb"
        end


        def execute_bundle_install
          log :execute_bundle_install, ""
          in_root { run "bundle" }
        end


      end
    end
  end
end
