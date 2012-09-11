# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_decorators/version'

Gem::Specification.new do |gem|
  gem.name          = "ruby_decorators"
  gem.version       = RubyDecorators::VERSION
  gem.authors       = ["Fred Wu"]
  gem.email         = ["ifredwu@gmail.com"]
  gem.description   = %q{Ruby method decorators inspired by Python.}
  gem.summary       = gem.description
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'minitest'
end