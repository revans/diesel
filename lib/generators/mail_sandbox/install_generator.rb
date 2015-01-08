require 'rails/generators'
require_relative '../../diesel/actions'

module Diesel
  module Mail
    module Generators
      class InstallGenerator < Rails::Generators::Base
        include ::Diesel::Actions

        desc "Mail Sandboxing"

        source_root File.expand_path('../templates', __FILE__)
        class_option :template_engine

        def initialize(args = [], options = {}, config = {})
          super(args, options, config)
        end

        def raise_mail_delivery_errors_in_development
          log :raise_mail_delivery_errors_in_development, ''
          replace_in_file "config/environments/development.rb",
                          "raise_delivery_errors = false",
                          "raise_delivery_errors = true"
        end

        def create_development_interceptor
          log :create_development_interceptor, ''
          copy_file 'mailers/sandbox_email_interceptor.rb',
                    'app/mailers/sandbox_email_interceptor.rb'
        end

        def register_interceptor
          log :register_interceptor, ''
          initializer "sandbox_email_interceptor.rb",
              "ActionMailer::Base.register_interceptor(SandboxEmailInterceptor) unless Rails.env.production?"
        end

      end
    end
  end
end