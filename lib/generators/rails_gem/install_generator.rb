require 'rails/generators'
require_relative '../../featurette/actions'

module Featurette
  module RailsGem
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        include ::Featurette::Actions

        desc "Generates a Rails RubyGem Skeleton inside of a Rails application's lib directory."

        source_root ::File.expand_path("../templates", __FILE__)
        class_option :template_engine
        class_option :gem_name, type: :string, aliases: '-n', desc: 'Rails RubyGem name'
        class_option :skip_git, type: :boolean, default: false, desc: 'Skip .gitignore file'

        def initialize(args = [], options = {}, config = {})
          super(args, options, config)
          @gempath      = "lib/#{name}_gem/lib"
          @gem_testpath = "lib/#{name}_gem/test"
        end

        def create_gem_directory
          in_root do
            mkdir_p "#{@gempath}/#{name}"
            mkdir_p "#{@gempath}/#{name}/rails"
            mkdir_p @gem_testpath
          end
        end

        def engine
          template "main.rb",     "#{@gempath}/#{name}.rb"
          template "engine.rb",   "#{@gempath}/#{name}/rails/engine.rb"
        end

        def gem_version
          template "gem_version.rb",   "#{@gempath}/#{name}/gem_version.rb"
          template "version.rb",       "#{@gempath}/#{name}/version.rb"
        end

        def test
          template "test/test_helper.rb", "#{@gem_testpath}/test_helper.rb"
        end

        def rakefile
          template "Rakefile", "#{@gempath}/../Rakefile"
        end

        def changelog
          template "CHANGELOG.md", "#{@gempath}/../CHANGELOG.md"
        end

        def gemfile
          template "Gemfile", "#{@gempath}/../Gemfile"
        end

        def license
          template "MIT-LICENSE", "#{@gempath}/../MIT-LICENSE"
        end

        def readme
          template "README.md", "#{@gempath}/../README.md"
        end

        def gemspec
          template "main.gemspec", "#{@gempath}/../#{name}.gemspec"
        end

        def gitignore
          template "gitignore", "#{@gempath}/../.gitignore"
        end


        protected

        def name
          @name ||= begin
            # same as ActiveSupport::Inflector#underscore except not replacing '-'
            underscored = options[:gem_name].dup
            underscored.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
            underscored.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
            underscored.downcase!

            underscored
          end
        end


        def camelized
          @camelized ||= name.gsub(/\W/, '_').squeeze('_').camelize
        end

        def original_name
          @original_name ||= File.basename(destination_root)
        end

        def author
          default = "TODO: Write your name"
          if skip_git?
            @author = default
          else
            @author = `git config user.name`.chomp rescue default
          end
        end

        def email
          default = "TODO: Write your email address"
          if skip_git?
            @email = default
          else
            @email = `git config user.email`.chomp rescue default
          end
        end

        def skip_git?
          options[:skip_git]
        end

      end
    end
  end
end
