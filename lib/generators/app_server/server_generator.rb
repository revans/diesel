require 'rails/generators'
require_relative '../../diesel/actions'

module Diesel
  module Generators
    class ServerGenerator < ::Rails::Generators::Base
      include ::Diesel::Actions

      desc "Application Server Setup"

      source_root ::File.expand_path("../templates", __FILE__)
      class_option :template_engine

      def initialize(args = [], options = {}, config = {})
        super(args, options, config)
      end

      def support_for_app_server
        log :support_for_app_server, ""

        case options[:app_server]
        when 'puma'
          gem "puma"
          template "config/puma.conf.erb",  'config/puma.conf'
          copy_file "procfile.puma",        'Procfile'

        when 'thin'
          gem "thin"
          template "config/thin.conf.erb",  'config/thin.conf'
          copy_file "procfile.thin",        'Procfile'

        else
          gem "unicorn"
          template "config/unicorn.rb.erb", 'config/unicorn.rb'
          copy_file "procfile.ubuntu",      'Procfile'

        end
      end


      def copy_nginx_config
        log :copy_nginx_config, ""

        template  "config/nginx.conf.erb",
                  "config/nginx.conf",
                  force: true
      end

      def copy_profile
        log :copy_profile, ""
        copy_file "procfile.dev",  'Procfile.dev'
      end

      def create_pids_folder
        log :create_pids_folder, ""
        empty_directory "tmp/pids"
      end

      def create_sockets_folder
        log :create_sockets_folder, ""
        empty_directory "tmp/sockets"
      end

      def add_logger_sync_for_foreman
        log :add_logger_sync_for_foreman, ""
        prepend_file "config/environments/development.rb", "STDOUT.sync = true\n\n"
      end

      def setup_foreman
        log :setup_foreman, ""
        gem "foreman"
      end

      def execute_bundle_install
        log :execute_bundle_install, ""
        in_root { run "bundle" }
      end

    end
  end

end
