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

      # def add_testing_api_gem
      #   log :add_testing_api_gem, ""
      #
      #   gem_group :development, :test do
      #     gem 'gorillapi', github: 'revans/gorillapi'
      #   end
      # end

      # def add_ping_controller
      #   log :add_ping_controller, ''
      #
      #   copy_file 'controllers/ping_controller.rb',
      #     'app/controllers/ping_controller.rb'
      # end


      def copy_auth_files
        log :copy_auth_files, ""

        copy_file "controllers/api_authentication.rb",
            'app/controllers/concerns/api_authentication.rb'

        copy_file "controllers/api_versioning.rb",
            'app/controllers/concerns/api_versioning.rb'

        copy_file "test/api_helper.rb",
                  'test/support/api_helper.rb'

        copy_file "test/authorization_helper.rb",
                  'test/support/authorization_helper.rb'


        inject_into_file 'test/test_helper.rb',
            "\nclass ActionController::TestCase\n  include ::ApiHelper\nend",
            after: "end\n"


        # copy_file "config/api.yml", "config/api.yml"
      end


      def include_session_auth_concern
        log :include_session_auth_concern, ""
        content = <<-EOF
  include ApiAuthentication
  include ApiVersioning

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


      def copy_disable_xml_params
        log :copy_disable_xml_params, ""

        copy_file "initializers/disable_xml_params.rb",
                  'config/initializers/disable_xml_params.rb'
      end

      # def copy_api_test_rake_tasks
      #   log :copy_api_test_rake_tasks, ""
      #
      #   copy_file "tasks/api.rake",
      #             'lib/tasks/api.rake'
      # end



      def copy_api_docs_starterkit
        log :copy_api_docs_starterkit, ""

        mkdir_p   "doc"

        template  "doc/api_doc.mkd.erb",
                  'doc/api.markdown',
                  force: true
      end


      # def copy_api_config
      #   log :copy_api_config, ""
      #
      #   copy_file "config/api.yml",  "config/api.yml"
      #   copy_file "lib/api_test.rb", "lib/api_test.rb"
      # end


      def execute_bundle_install
        log :execute_bundle_install, ""
        in_root { run "bundle" }
      end


    end
  end

end
