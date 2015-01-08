require 'thor/group'
require 'rails/generators/actions'
require 'pathname'
require 'fileutils'

module Diesel
  module Actions

    def touch(filename)
      log :touch, filename
      in_root { run "touch #{filename}" }
    end


    def mkdir_p(dir)
      log :mkdir_p, dir
      in_root { run "mkdir -p #{dir}" }
    end


    def executable(filename)
      log :executable, filename
      in_root { run "chmod a+x #{filename}" }
    end


    def stylesheet(filename, data=nil, &block)
      log :stylesheet, filename
      create_file("app/assets/stylesheets/#{filename}", data, verbose: false, &block)
    end


    def javascript(filename, data=nil, &block)
      log :javascript, filename
      create_file("app/assets/javascripts/#{filename}", data, verbose: false, &block)
    end


    # add_to_stylesheet_manifest "buttons", after:  '*= require_tree .'
    # add_to_stylesheet_manifest "buttons", before: '*= require_tree .'
    # add_to_stylesheet_manifest "buttons", after:  /\*= require_tree \.*$/
    #
    def add_to_stylesheet_manifest(filename, options={})
      log :add_to_stylesheet_manifest, filename

      sentinel = options.has_key?(:after) ? " *= require #{filename}\n" : "\n *= require #{filename}"

      in_root do
        inject_into_file 'app/assets/stylesheets/application.css', sentinel, options.merge(verbose: false)
      end
    end


    # import_stylesheet_into_manifet "flat-ui-pro.min", after: "bootstrap"
    #
    def add_import_to_stylesheet_manifest(filename, opts = {})
      log :import_stylesheet_into_manifest
      sentinel  = "\n@import \"#{filename}\";"
      options   = { after: "@import \"#{opts[:after]}\";", verbose: false }

      in_root do
        inject_into_file "app/assets/stylesheets/application.css.scss", sentinel, options
      end
    end


    # add_to_javascript_manifest "angular", after:  '//= require jquery_ujs'
    # add_to_javascript_manifest "angular", before: '//= require jquery_ujs'
    # add_to_javascript_manifest "angular", after:  /\/\/= require jquery_ujs*$/
    #
    def add_to_javascript_manifest(filename, options={})
      log :add_to_javascript_manifest, filename

      sentinel = options.has_key?(:after) ? " //= require #{filename}\n" : "\n //= require #{filename}"

      in_root do
        inject_into_file 'app/assets/javascripts/application.js', sentinel, options.merge(verobose: false)
      end
    end


    def replace_in_file(relative_path, find, replace)
      path      = ::File.join(destination_root, relative_path)
      contents  = ::IO.read(path)

      unless contents.gsub!(find, replace)
        raise "#{find.inspect} not found in #{relative_path}"
      end

      ::File.open(path, "w") { |file| file.write(contents) }
    end



    def application_name
      if defined?(Rails) && ::Rails.application
        ::Rails.application.class.name.split('::').first.underscore
      else
        "application"
      end
    end


  end
end
