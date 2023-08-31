# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jsonapi/matchers/version'

Gem::Specification.new do |spec|
  spec.name          = "jsonapi-matchers"
  spec.version       = Jsonapi::Matchers::VERSION
  spec.authors       = ['Popular Pays']
  spec.email         = ['engineering@popularpays.com']

  spec.summary       = %q{A gem for testing the presence of specific resources in a json api response}
  spec.homepage      = "https://github.com/popularpays/jsonapi-matchers"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.7.8"

  spec.add_dependency "activesupport", ">= 4.0", "< 7.1"
  spec.add_dependency "awesome_print"

  spec.add_development_dependency "bump", "~> 0.9.0"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
