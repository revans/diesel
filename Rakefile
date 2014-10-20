require 'rake/testtask'
require 'rubygems/package_task'

spec = eval(::File.read('featurette.gemspec'))

Gem::PackageTask.new(spec) do |p|
  p.gem_spec = spec
end

desc 'Release to RubyGems'
task :release => :package do
  require 'rake/gemcutter'
  Rake::Gemcutter::Tasks.new(spec).define
  Rake::Task['gem:push'].invoke
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

task :default => true


require 'pathname'
require 'fileutils'
require 'active_support/core_ext/string/inflections'

module CreateNewGenerator
  extend self

  def run!(name)
    generators  = ::Pathname.new(__dir__).join("lib/generators")
    lib         = generators.join(name)

    content = <<-EOF
require 'rails/generators'
require_relative '../../featurette/actions'

module Featurette
  module #{name.classify}
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        include ::Featurette::Actions

        desc ""

        source_root ::File.expand_path("../templates", __FILE__)
        class_option :template_engine

        def initialize(args = [], options = {}, config = {})
          super(args, options, config)
        end

      end
    end
  end
end
    EOF

    lib.join("templates").mkpath
    File.open(lib.join("install_generator.rb"), "wb") do |file|
      file.write content
    end

    puts "--> Created a new Generator named #{name.classify} located in #{lib.to_s}"
  end

end


namespace :generator do
  desc "Create a new generator"
  task :new do
    name = ARGV.last.split('=').last
    ::CreateNewGenerator.run!(name)
  end

  desc "Help"
  task :help do
    puts "Create a new generator like so: rake generator:new NAME=admin"
  end
end
