require 'rails/generators'
require_relative '../../featurette/actions'

module Featurette
  module Frontend
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        include ::Featurette::Actions

        desc "Frontend support"

        source_root ::File.expand_path("../templates", __FILE__)
        class_option :template_engine

        def initialize(args = [], options = {}, config = {})
          super(args, options, config)
        end

        def create_font_directory
          log :create_font_directory, 'Creating a font directory'
          empty_directory "app/assets/fonts"
        end

        def configure_app_generators
          log :configure_app_generators, ''
          generators_config = <<-CON

    # don't have rails create stylesheets or javascript files
    config.generators do |g|
      g.assets          false
      g.helper          false
    end

          CON

          application generators_config
        end

        def add_bootstrap_gems
          log :add_bootstrap_gems, ''
          gem "bootstrap-sass"
          gem "font-awesome-sass"
          gem "autoprefixer-rails"
        end

        def copy_stylesheet_helpers
          log :copy_stylesheet_helpers, ''
          mkdir_p "app/assets/stylesheets/helpers"

          %w|
              buttons
              colors
              flashes
              fonts
              utilities
              variables
              mixins
              functions
              base|.each do |css|

            copy_file "assets/stylesheets/#{css}.css.scss",
                      "app/assets/stylesheets/helpers/#{css}.css.scss"
          end
        end

        def install_normalize
          log :install_normalize, ''
          in_root do
            run "curl https://raw.githubusercontent.com/necolas/normalize.css/master/normalize.css > vendor/assets/stylesheets/normalize.css"
          end
        end


        def bootstrap_helper
          log :bootstrap_helper, ''
          copy_file "helpers/bootstrap_helper.rb",
                    'app/helpers/bootstrap_helper.rb'
        end


        def add_bootstrap_javascript_files
          log :add_bootstrap_javascript_files, ''
          add_to_javascript_manifest 'bootstrap-sprockets', after: '//= require jquery_ujs'
        end

        def recreate_application_stylesheet
          log :recreate_application_stylesheet, ''
          remove_file "app/assets/stylesheets/application.css"
          copy_file "assets/stylesheets/application.css.scss",
                    'app/assets/stylesheets/application.css.scss'
        end

        def customize_error_pages
          log :customize_error_pages, ''

          meta_tags = <<-EOS
  <meta charset='utf-8' />
  <meta name='ROBOTS' content='NOODP' />
          EOS

          in_root do
            %w(500 404 422).each do |page|
              inject_into_file "public/#{page}.html", meta_tags, :after => "<head>\n"
              replace_in_file "public/#{page}.html", /<!--.+-->\n/, ''
            end
          end
        end

        def create_humans_text
          log :create_humans_text, ''

          copy_file "public/humans.txt", 'public/humans.txt'
        end


        def create_views_directories
          log :create_views_directories, ''

          empty_directory "app/views/application"
        end

        def create_application_layout
          log :create_application_layout, ''
          remove_file "app/views/layouts/application.html.erb"

          copy_file "partials/app_layout.html.erb",
                    'app/views/layouts/application.html.erb'
        end

        def copy_views_application_partials
          log :copy_views_application_partials, ''

          copy_file "partials/flashes.html.erb",      'app/views/application/_flashes.html.erb'
          copy_file "partials/nav.html.erb",          'app/views/application/_nav.html.erb'
          copy_file "partials/doctype.html.erb",      'app/views/application/_doctype.html.erb'
          copy_file "partials/footer.html.erb",       'app/views/application/_footer.html.erb'
          copy_file "partials/form_errors.html.erb",  'app/views/application/_form_errors.html.erb'
        end


        def execute_bundle_install
          log :execute_bundle_install, ""
          in_root { run "bundle" }
        end

      end
    end
  end
end
