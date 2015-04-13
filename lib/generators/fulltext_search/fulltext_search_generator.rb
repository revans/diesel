require 'rails/generators'
require_relative '../../diesel/actions'

module Diesel
  module Generators
    class FullTextSearchGenerator < Rails::Generators::Base
      include ::Diesel::Actions

      desc "Full Text Searching"

      source_root File.expand_path('../templates', __FILE__)
      class_option :template_engine

      def initialize(args = [], options = {}, config = {})
        super(args, options, config)
      end

      def create_migration_for_postgresql_extensions
        log :create_migration_for_postgresql_extensions, ''

        generate :migration, "search_extensions",
                    'execute "create extension if not exists pg_trgm;"',
                    'execute "create extension if not exists fuzzystrmatch;"',
                    'execute "create extension if not exists unaccent;"'


      end

      def install_pg_search_gem
        log :install_pg_search_gem
        gem 'pg_search'
      end

      def execute_bundle_install
        log :execute_bundle_install, ""
        in_root { run "bundle" }
      end


      def instructions
        puts
        puts '*' * 80
        puts
        puts "To use the Search, add this to your model: include PgSearch"
        puts
        puts "e.g."
        puts
        puts "pg_search_scope :search, against: [:name, :description], ignoring: :accents"
        puts "using: { tsearch: { prefix: true, dictionary: 'english' } }"
        puts
        puts "Add indexes:"
        puts 'execute "create index models_name on models using gin(to_tsvector(\'english\', column_name))"'
        puts ''
        puts
      end


    end
  end
end