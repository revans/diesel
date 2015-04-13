require 'rails/generators'
require_relative '../../diesel/actions'

module Diesel
  module Generators
    class CommentGenerator < ::Rails::Generators::Base
      include ::Diesel::Actions

      desc "Comments Support"

      source_root ::File.expand_path("../templates", __FILE__)
      class_option :template_engine

      def initialize(args = [], options = {}, config = {})
        super(args, options, config)
      end

      def copy_concerns
        log :copy_concerns, ''

        # Controller
        copy_file "app/controllers/concerns/commentable.rb",
                  "app/controllers/concerns/commentable.rb"
        # Model
        copy_file "app/models/concerns/commentable.rb",
                  "app/models/concerns/commentable.rb"
      end

      def generate_comment
        log :generate_comment, ''

        generate :model, "comment", "content:text",
                                    "commentable_id:integer:index",
                                    "commentable_type:string:index",
                                    "user:belongs_to"
      end

      def insert_polymorphism
        log :insert_polymorphism, ''

        inject_into_file 'app/models/comment.rb',
        "  belongs_to :commentable, polymorphic: true\n",
        after: "class Comment < ActiveRecord::Base\n"
      end

      def execute_bundle_install
        log :execute_bundle_install, ""
        in_root { run "bundle" }
      end

    end
  end
end
