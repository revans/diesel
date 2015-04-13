require 'rails/generators'
require_relative '../../diesel/actions'

module Diesel
  module Generators
    class HerokuizeGenerator < Rails::Generators::Base
      include ::Diesel::Actions

      desc "Gems for working on Heroku"

      source_root File.expand_path('../templates', __FILE__)
      class_option :template_engine

      def initialize(args = [], options = {}, config = {})
        super(args, options, config)
      end

      def add_heroku_config
        log :add_heroku_config, ""
        copy_file "bin/heroku-config.rb",
                  'bin/heroku-config'
      end

      def add_redis_conf
        log :add_redis_conf, ""

        template  "config/initializer/redis.rb.erb",
                  "config/initializer/redis.rb",
                  force: true
      end

      def add_sidekiq_yml
        log :add_sidekiq_yml, ''
        copy_file "config/sidekiq.yml", "config/sidekiq.yml"
      end

      def add_heroku_related_gems
        log :add_heroku_related_gems, ""

        gem_group :production, :staging do
          gem 'rails_12factor'
          gem "rollbar"
          gem 'newrelic_rpm'

          gem 'mandrill-api', require: 'mandrill'
          # gem 'zero_push'

          gem 'sidekiq'
          gem 'sinatra'
          gem "rack-timeout"
        end
      end

      def execute_bundle_install
        log :execute_bundle_install, ""
        in_root { run "bundle" }
      end

      def run_rollbar_config
        in_root do
          system 'rails g rollbar:rollbar'
        end
      end

      # def run_zeropush_config
      #   in_root do
      #     system 'rails g zero_push:install'
      #   end
      # end

    end
  end
end