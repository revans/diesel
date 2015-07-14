require 'rails/generators'
require_relative '../../diesel/actions'

module Diesel
  module Generators
    class DefaultsGenerator < ::Rails::Generators::Base
      include ::Diesel::Actions

      desc "Runs the typical diesel generators"

      source_root ::File.expand_path("../templates", __FILE__)
      class_option :template_engine

      def initialize(args = [], options = {}, config = {})
        super(args, options, config)
      end


      def run_default_install
        log :run_default_install

        generate :diesel, "timezone"
        generate :diesel, "mail"
        generate :diesel, "bootstrap"
        generate :diesel, "frontend"
        generate :diesel, "server"
        generate :diesel, "geo"
      end


    end
  end
end
