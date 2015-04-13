require 'rails/generators'
require_relative '../../diesel/actions'

module Diesel
  module Generators
    class TimezoneGenerator < Rails::Generators::Base
      include ::Diesel::Actions

      desc "Normalize Timezones"

      source_root File.expand_path('../templates', __FILE__)
      class_option :template_engine

      def initialize(args = [], options = {}, config = {})
        super(args, options, config)
      end

      def add_database_utc_setting
        log :add_database_utc_setting, ''
        application "config.active_record.default_timezone = :utc"
      end

      def ignore_assets_and_helper_generators
        log :ignore_assets_and_helper_generators, ''
        generators_config = <<-CON

    # don't have rails create stylesheets or javascript files
    config.generators do |g|
      g.assets          false
      g.helper          false
    end

        CON

        application generators_config
      end

      def add_local_time_gem
        log :add_local_time_gem, ''
        gem "local_time"
      end

      def execute_bundle_install
        log :execute_bundle_install, ""
        in_root { run "bundle" }
      end

    end
  end

end