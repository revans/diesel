require 'rails/generators'
require_relative '../../diesel/actions'

module Diesel
  module Bootstrap
    module Generators

      class InstallGenerator < ::Rails::Generators::Base
        include ::Diesel::Actions

        desc "Add Bootstrap Support"

        source_root ::File.expand_path("../templates", __FILE__)
        class_option :template_engine

        def initialize(args = [], options = {}, config = {})
          super(args, options, config)
        end

        def bootstrap_helper
          log :bootstrap_helper, ''
          copy_file "helpers/bootstrap_helper.rb",
                    'app/helpers/bootstrap_helper.rb'

          copy_file "helpers/bootstrap_helper_test.rb",
                    'test/helpers/bootstrap_helper_test.rb'
        end

        def copy_stylesheet_helpers
          log :copy_stylesheet_helpers, ''
          mkdir_p "app/assets/stylesheets/helpers"

          %w|fonts|.each do |css|

            copy_file "assets/stylesheets/#{css}.scss",
                      "app/assets/stylesheets/helpers/#{css}.scss"
          end
        end


        def add_bootstrap_javascript_files
          log :add_bootstrap_javascript_files, ''
          add_to_javascript_manifest 'bootstrap-sprockets', after: "//= require jquery_ujs\n"
        end

        def recreate_application_stylesheet
          log :recreate_application_stylesheet, ''
          content = <<-EOF

@import "bootstrap-sprockets";
@import "bootstrap";
@import "font-awesome-sprockets";
@import "font-awesome";


@import "helpers/fonts";

          EOF
          inject_into_file "app/assets/stylesheets/application.scss", content,
                after:    " */",
                verbose:  false
        end

        def copy_views_application_partials
          log :copy_views_application_partials, ''

          copy_file "partials/flashes.html.erb",      'app/views/application/_flashes.html.erb'
          copy_file "partials/nav.html.erb",          'app/views/application/_nav.html.erb'
          copy_file "partials/form_errors.html.erb",  'app/views/application/_form_errors.html.erb'
        end

        def add_bootstrap_gems
          log :add_bootstrap_gems, ''
          gem "bootstrap-sass"
          gem "font-awesome-sass"
          gem "autoprefixer-rails"
        end

        def execute_bundle_install
          log :execute_bundle_install, ""
          in_root { run "bundle" }
        end

      end

    end
  end
end
