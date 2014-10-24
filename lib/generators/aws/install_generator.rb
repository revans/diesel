require 'rails/generators'
require_relative '../../featurette/actions'

module Featurette
  module Aw
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