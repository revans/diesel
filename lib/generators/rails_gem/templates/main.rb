require 'rails'
require '<%= name %>/version'
require '<%= name %>/rails/engine'

module <%= camelized %>
  module Rails
    class Railtie < ::Rails::Railtie

      initializer "<%= name %>.setup", group: :all do |app|
      end

    end
  end
end
