lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "busser/rspec/version"

Gem::Specification.new do |spec|
  spec.name          = "busser-rspec"
  spec.version       = Busser::Rspec::VERSION
  spec.authors       = ["Adam Jacob"]
  spec.email         = ["adam@opscode.com"]
  spec.description   = "A Busser runner plugin for RSpec"
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/test-kitchen/busser-rspec"
  spec.license       = "Apache-2.0"

  spec.required_ruby_version = ">= 3.2"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.metadata = {
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/blob/main/CHANGELOG.md",
    "documentation_uri" => "#{spec.homepage}/blob/main/README.md",
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
  }

  spec.add_dependency "busser", ">= 0.9.0"
end
