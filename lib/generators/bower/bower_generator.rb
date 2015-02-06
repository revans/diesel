require 'rails/generators'
require_relative '../../diesel/actions'

module Diesel
  module Generators
    class BowerGenerator < ::Rails::Generators::Base
      include ::Diesel::Actions

      desc "Add Bower Support"

      source_root ::File.expand_path("../templates", __FILE__)
      class_option :template_engine

      def initialize(args = [], options = {}, config = {})
        super(args, options, config)
      end


      def create_bowerrc
        create_file ".bowerrc", <<-BOW
{
  "directory": "vendor/assets/bower_components",
  "json": "bower.json"
}
        BOW
      end

      def run_bower_init
        create_file "bower.json", <<-BOWERJSON
{
  "name": "#{application_name}",
  "version": "0.0.01",
  "authors": [
    "#{`whoami`.chomp}"
  ],
  "license": "MIT",
  "ignore": [
    "**/.*",
    "node_modules",
    "bower_components",
    "vendor/assets/bower_components",
    "test",
    "tests"
  ],
  "dependencies": {
  }
}
        BOWERJSON
      end

      def add_bower_to_asset_pipeline
        application "config.assets.paths << ::Rails.root.join('vendor/assets/bower_components')"
      end


      def run_bundle_for_new_gems
        in_root do
          run "bundle"
        end
      end


      def application_name
        if defined?(Rails) && Rails.application
          Rails.application.class.name.split('::').first.underscore
        else
          "application"
        end
      end

    end
  end

end
