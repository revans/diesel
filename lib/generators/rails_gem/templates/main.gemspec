# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "<%= name %>/version"


Gem::Specification.new do |s|
  s.platform      = Gem::Platform::RUBY
  s.name          = "<%= name %>"
  s.version       = <%= camelized %>.version
  s.summary       = "Summary of <%= camelized %>."
  s.description   = "Description of <%= camelized %>."

  s.license       = "MIT"

  s.author        = "<%= author %>"
  s.email         = "<%= email %>"
  s.homepage      = ""

  s.file          = Dir['CHANGELOG.md', 'MIT-LICENSE', 'README.md', 'lib/**/*']
  s.test_files    = Dir['test/**/*']

  s.require_paths = ["lib"]
  s.bindir        = 'bin'
  s.executables   = ['<%= name %>']

  # Development Dependencies
  s.add_development_dependency 'minitest'

  # Runtime Dependencies
  s.add_dependency 'railtie', '~> 4.1'
end
