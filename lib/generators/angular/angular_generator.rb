require 'rails/generators'
require_relative '../../diesel/actions'

module Diesel
  module Generators
    class AngularGenerator < ::Rails::Generators::Base
      include ::Diesel::Actions

      desc "Angular.js"

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
  "dependencies": {},
  "license": "MIT",
  "ignore": [
    "**/.*",
    "node_modules",
    "bower_components",
    "vendor/assets/bower_components",
    "test",
    "tests"
  ]
}
        BOWERJSON
      end

      def add_bower_to_asset_pipeline
        application "config.assets.paths << ::Rails.root.join('vendor/assets/bower_components')"
      end

      def install_angular_libraries
        in_root do
          run "bower install angularjs --save"
          run "bower install angular-resource --save"
          run "bower install angular-sanitize --save"
          run "bower install angular-cookies --save"
          run "bower install angular-route --save"
          run "bower install angular-scenario --save"
          run "bower install angular-touch --save"
          run "bower install angular-animate --save"
          run "bower install angular-loader --save"
          run "bower install angular-mocks --save"
        end
      end

      def add_angular_csrf_support
        inject_into_file( "app/controllers/application_controller.rb",
                         after: "protect_from_forgery with: :exception") do
          <<-'RUBY'

after_action :set_csrf_cookie_for_angular, if: :json_requested?

private

def set_csrf_cookie_for_angular
  cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
end

def verified_request?
  super || form_authenticity_token == request.headers['HTTP_X_XSRF_TOKEN']
end

def json_requested?
  request.format.json?
end

          RUBY
        end
      end


      def add_cors_support
        gem 'rack-cors', require: 'rack/cors'

        application do
          <<-'RUBY'

  # Cross Origin Support using Rack Cors library
  config.middleware.use ::Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: [:get, :post, :options, :delete]
    end
  end

          RUBY
        end
      end


      def add_javascript_angular_loader
        content = <<-CON
@App = angular.module('#{application_name.classify}', ['ngResource'])

@App.config ($httpProvider) ->
  authToken = angular.element('meta[name="csrf-token"]').attr('content')
  $httpProvider.defaults.headers.common['X-CSRF-TOKEN'] = authToken
  return

$(document).on "ready page:load", ->
  angular.bootstrap document.body, ['#{application_name.classify}']
  return
        CON

        create_file "app/assets/javascripts/angular_setup.js.coffee", content
      end


      def update_application_js
        in_root do
          %w|models controllers|.each do |dir|
            run "mkdir -p app/assets/javascripts/#{dir}"
            run "touch app/assets/javascripts/#{dir}/.gitkeep"
          end
          run "mkdir -p app/assets/templates"
          run "touch app/assets/templates/.gitkeep"
        end


        insert_into_file( 'app/assets/javascripts/application.js',
                          after: "//= require jquery_ujs\n") do
          <<-'RUBY'
//= require angular/angular.min
//= require angular-resource/angular-resource.min
//= require angular-sanitize/angular-sanitize.min
//= require angular_setup
          RUBY
        end

        insert_into_file( 'app/assets/javascripts/application.js',
                          after: "//= require_tree .\n") do
          <<-'RUBY'
//= require_tree ./models
//= require_tree ./controllers
//= require_tree ../templates
          RUBY
        end
      end

      def install_angular_templates_gem
        gem 'angular-rails-templates'
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
