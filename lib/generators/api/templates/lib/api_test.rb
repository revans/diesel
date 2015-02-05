#!/usr/bin/env ruby
#
# Loads the Rails environment, requires the gorillapi library
# and some sample modules that have sample data.
#

if Rails.env.development?
  ENV['RAILS_ENV'] ||= 'development'
  require File.expand_path('../../config/environment', __FILE__)
  require 'json'
  require 'gorillapi'

  module Api
    extend Gorillapi
    extend self

    test_api    url: ::Rails.application.config_for(:api)["url"]


    header  header_name:  ::Rails.application.config_for(:api)["header_name"],
            api_key:      ::Rails.application.config_for(:api)["token"],
            format:       ::Rails.application.config_for(:api)["format"],
            version:      ::Rails.application.config_for(:api)["version"]

    def ping
      get "/ping"
    end

  end
end
