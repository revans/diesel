require 'rails/generators'
require_relative '../../diesel/actions'

module Diesel
  module Generators
    class LikableGenerator < ::Rails::Generators::Base
      include ::Diesel::Actions

      desc "Likable Support"

      source_root ::File.expand_path("../templates", __FILE__)
      class_option :template_engine

      def initialize(args = [], options = {}, config = {})
        super(args, options, config)
      end

      def copy_concerns
        log :copy_concerns, ''

        # Model
        copy_file "app/models/concerns/likable.rb",
                  "app/models/concerns/likable.rb"
      end

      def generate_likes
        log :generate_likes, ''

        generate :model, "likes",   "number:integer",
                                    "likable_id:integer:index",
                                    "likable_type:string:index",
                                    "user:belongs_to"
      end

      def insert_polymorphism
        log :insert_polymorphism, ''

        inject_into_file 'app/models/like.rb',
        "  belongs_to :likable, polymorphic: true\n",
        after: "class Like < ActiveRecord::Base\n"
      end

    end
  end
end
