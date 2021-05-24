# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'busser/rspec/version'

Gem::Specification.new do |spec|
  spec.name          = 'busser-rspec'
  spec.version       = Busser::Rspec::VERSION
  spec.authors       = ['Adam Jacob']
  spec.email         = ['adam@opscode.com']
  spec.description   = %q{A Busser runner plugin for RSpec}
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/adamhjk/busser-rspec'
  spec.license       = 'Apache 2.0'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'busser'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'chef'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'aruba'
  spec.add_development_dependency 'cane'
  spec.add_development_dependency 'tailor'
  spec.add_development_dependency 'countloc'
end
