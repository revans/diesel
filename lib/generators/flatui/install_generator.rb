require 'rails/generators'
require_relative '../../featurette/actions'

module Featurette # :nodoc
  module Flatui
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        include ::Featurette::Actions

        desc "Generate Flat-UI Frontend Resources"

        source_root ::File.expand_path("../templates", __FILE__)
        class_option :template_engine

        def initialize(args = [], options = {}, config = {})
          super(args, options, config)
        end

        def copy_css
          copy_file "css/flat-ui-pro.css.map",  "vendor/assets/stylesheets/flat-ui-pro.css.map"
          copy_file "css/flat-ui-pro.min.css",  "vendor/assets/stylesheets/flat-ui-pro.min.css"
          copy_file "css/colors.css.scss",      "app/assets/stylesheets/helpers/flat_colors.css.scss"
        end

        def copy_fonts
          directory "fonts/glyphicons", "app/assets/fonts/glyphicons"
          directory "fonts/lato",       "app/assets/fonts/lato"
        end

        def copy_images
          directory "images/glyphs",    "app/assets/images/glyphs"
          directory "images/icons",     "app/assets/images/icons"
        end

        def copy_js
          copy_file "js/flat-ui-pro.min.js", "vendor/assets/javascripts/flat-ui-pro.min.js"
        end

        def include_css
          add_import_to_stylesheet_manifest "flat-ui-pro.min",      after: 'bootstrap'
          add_import_to_stylesheet_manifest "helpers/flat_colors",  after: 'flat-ui-pro.min'
        end

        def include_js
          add_to_javascript_manifest 'flat-ui-pro.min', after: '//= require bootstrap-sprockets'
        end

      end
    end
  end
end
