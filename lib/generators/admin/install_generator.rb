require 'rails/generators'
require_relative '../../featurette/actions'

module Featurette
  module Admin
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        include ::Featurette::Actions

        desc "Generates the foundation for building an admin system"

        source_root ::File.expand_path("../templates", __FILE__)
        class_option :template_engine

        def initialize(args = [], options = {}, config = {})
          super(args, options, config)
        end


        def copy_admin_controller
          mkdir_p   "app/controllers/admin"

          copy_file "controllers/admin_controller.rb",
                    'app/controllers/admin/admin_controller.rb'
        end

        def add_admin_namespaced_route
          admin_namespace = <<-NAMESPACE

  namespace :admin do
    # ....
  end

          NAMESPACE
        end


        def execute_bundle_install
          log :execute_bundle_install, ""
          in_root { run "bundle" }
        end

      end
    end
  end
end
