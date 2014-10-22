require 'rails/generators'
require_relative '../../featurette/actions'

module Featurette
  module AppServer
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        include ::Featurette::Actions

        desc "Application Server Setup"

        source_root ::File.expand_path("../templates", __FILE__)
        class_option :template_engine

        def initialize(args = [], options = {}, config = {})
          super(args, options, config)
        end

        def add_server_gems
          gem "foreman"
          gem 'unicorn'     if options[:app_server] == 'unicorn'
          gem 'puma'        if options[:app_server] == 'puma'
          gem 'thin'        if options[:app_server] == 'thin'
        end

        def copy_application_server_config
          template "config/unicorn.rb.erb", 'config/unicorn.rb'   if options[:app_server] == 'unicorn'
          template "config/puma.conf.erb",  'config/puma.conf'    if options[:app_server] == 'puma'
          template "config/thin.conf.erb",  'config/thin.conf'    if options[:app_server] == 'thin'
        end

        def copy_nginx_config
          template  "config/nginx.conf.erb",
                    "config/nginx.conf",
                    force: true
        end

        def copy_procfile
          copy_file "procfile.ubuntu",      'Procfile'      if options[:app_server] == 'unicorn'
          copy_file "procfile.puma",        'Procfile'      if options[:app_server] == 'puma'
          copy_file "procfile.thin",        'Procfile'      if options[:app_server] == 'thin'
          copy_file "procfile.dev",         'Procfile.dev'
        end

        def create_pids_folder
          empty_directory "tmp/pids"
        end

        def create_sockets_folder
          empty_directory "tmp/sockets"
        end

        def add_logger_sync_for_foreman
          prepend_file "config/environments/development.rb", "STDOUT.sync = true\n\n"
        end

        def execute_bundle_install
          log :execute_bundle_install, ""
          in_root { run "bundle" }
        end

      end
    end
  end
end
