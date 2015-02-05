require 'rails/generators'
require_relative '../../diesel/actions'

module Diesel
  module Generators
    class ApiGenerator < ::Rails::Generators::Base
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

      def add_ping_controller
        log :add_ping_controller, ''

        copy_file 'controllers/ping_controller.rb',
          'app/controllers/ping_controller.rb'
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



      def copy_api_docs_starterkit
        log :copy_api_docs_starterkit, ""

        mkdir_p   "doc"

        template  "doc/api_doc.mkd.erb",
                  'doc/api.markdown',
                  force: true
      end


      def copy_api_config
        log :copy_api_config, ""

        copy_file "config/api.yml",  "config/api.yml"
        copy_file "lib/api_test.rb", "lib/api_test.rb"
      end


      def execute_bundle_install
        log :execute_bundle_install, ""
        in_root { run "bundle" }
      end


    end
  end

end
