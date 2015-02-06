require 'rails/generators'
require_relative '../../diesel/actions'

module Diesel
  module Generators
    class AdminGenerator < ::Rails::Generators::Base
      include ::Diesel::Actions

      desc "Generates the foundation for building an admin system"

      source_root ::File.expand_path("../templates", __FILE__)
      class_option :template_engine

      def initialize(args = [], options = {}, config = {})
        super(args, options, config)
      end


      def copy_admin_controller
        log :copy_admin_controller, ""
        mkdir_p   "app/controllers/admin"

        copy_file "controllers/admin_controller.rb",
                  'app/controllers/admin/admin_controller.rb'
      end

      def add_admin_namespaced_route
        log :add_admin_namespaced_route, ""
        admin_namespace = <<-NAMESPACE

  namespace :admin do
    # ....
  end

        NAMESPACE

        inject_into_file "config/routes.rb",
          content,
          before: "end\n"
      end


      def add_is_user_admin_check
        log :add_is_user_admin_check, ""
        content = <<-EOF

  def is_admin?
    false
  end
        EOF

        inject_into_file "app/models/user.rb",
          content,
          before: "end\n"
      end


      def execute_bundle_install
        log :execute_bundle_install, ""
        in_root { run "bundle" }
      end

    end
  end

end
