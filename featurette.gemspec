# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'featurette/version'

Gem::Specification.new do |s|
  s.platform        = Gem::Platform::RUBY
  s.name            = "featurette"
  s.version         = Featurette.version
  s.author          = "Robert Evans"
  s.email           = "robert@codewranglers.org"
  s.homepage        = "TODO: Put your gem's website or public URL here."
  s.license         = "MIT-LICENSE"
  s.summary         = "TODO: Write a short summary."
  s.description     = "TODO: Write a longer description or delete this line."

  s.files           = Dir["CHANGELOG.md", "README.md", "MIT-LICENSE", "lib/**/*"]
  s.executables     = Dir["bin/*"]
  s.require_paths   = ["lib"]
  s.requirements    << 'none'

  s.add_development_dependency "rake",      "~> 10.0"
  s.add_development_dependency "minitest",  "~> 5.4"

  s.add_dependency 'railties'
  s.add_dependency 'bundler'
end
