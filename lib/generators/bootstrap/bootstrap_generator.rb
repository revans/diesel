require 'rails/generators'
require_relative '../../diesel/actions'

module Diesel
  module Generators

    class BootstrapGenerator < ::Rails::Generators::Base
      include ::Diesel::Actions

      desc "Add Bootstrap Support"

      source_root ::File.expand_path("../templates", __FILE__)
      class_option :template_engine

      def initialize(args = [], options = {}, config = {})
        super(args, options, config)
      end

      def create_directories
        log :create_views_directories, ''

        empty_directory "app/assets/fonts"
        empty_directory "app/views/application"

        copy_file "partials/flashes.html.erb",      'app/views/application/_flashes.html.erb'
        copy_file "partials/nav.html.erb",          'app/views/application/_nav.html.erb'
        copy_file "partials/form_errors.html.erb",  'app/views/application/_form_errors.html.erb'
        copy_file "partials/doctype.html.erb",      'app/views/application/_doctype.html.erb'
        copy_file "partials/footer.html.erb",       'app/views/application/_footer.html.erb'
      end

      def recreate_application_stylesheet
        log :recreate_application_stylesheet, ''
        remove_file "app/assets/stylesheets/application.css"
        copy_file "assets/stylesheets/application.scss",
                  'app/assets/stylesheets/application.scss'
      end

      def copy_stylesheet_helpers
        log :copy_stylesheet_helpers, ''
        mkdir_p "app/assets/stylesheets/helpers"

        copy_file "assets/stylesheets/fonts.scss",
                  "app/assets/stylesheets/helpers/fonts.scss"
      end


      def add_bootstrap_javascript_files
        log :add_bootstrap_javascript_files, ''
        add_to_javascript_manifest 'bootstrap-sprockets', after: "//= require jquery_ujs\n"
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

        copy_file "helpers/bootstrap_helper_test.rb",
                  'test/helpers/bootstrap_helper_test.rb'

        copy_file "helpers/ui_helper.rb",
                  'app/helpers/ui_helper.rb'

        copy_file "helpers/ui_helper_test.rb",
                  'test/helpers/ui_helper_test.rb'
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



      def create_application_layout
        log :create_application_layout, ''
        remove_file "app/views/layouts/application.html.erb"

        copy_file "partials/app_layout.html.erb",
                  'app/views/layouts/application.html.erb'
      end



      def add_font_location_to_assets_path
        log :add_font_location_to_assets_path, ''
        application "config.assets.paths << ::Rails.root.join('app/assets/fonts')"
      end

      def add_database_utc_setting
        log :add_database_utc_setting, ''
        application "config.active_record.default_timezone = :utc"
      end

      def copy_app_config
        log :copy_app_config, ''
        copy_file "config/app.yml", "config/app.yml"
      end




      def copy_settings_concern
        log :copy_settings_concern, ""
        copy_file "controllers/concerns/settings.rb",
                  "app/controllers/concerns/settings.rb"

        inject_into_file "app/controllers/application_controller.rb",
          "\n  include Settings\n",
          after: "protect_from_forgery with: :exception\n"

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
        gem "local_time"
        gem "kaminari"
      end

      def execute_bundle_install
        log :execute_bundle_install, ""
        in_root { run "bundle" }
      end

    end

  end

end
