require 'rails/generators'
require_relative '../../featurette/actions'

module Featurette
  module Geo
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        include ::Featurette::Actions

        desc "Doing geo related work"

        source_root ::File.expand_path("../templates", __FILE__)
        class_option :template_engine

        def initialize(args = [], options = {}, config = {})
          super(args, options, config)
        end

        def add_geocoding_methods
          log :add_geocoding_methods, ""
          copy_file "models/geocode_model_concern.rb",
                    'app/models/concerns/geocode_address.rb'
        end

        def add_geocoding_gems
          log :add_geocoding_gems, ""
          gem 'geocoder'
        end


        def execute_bundle_install
          log :execute_bundle_install, ""
          in_root { run "bundle" }
        end

      end
    end
  end
end
