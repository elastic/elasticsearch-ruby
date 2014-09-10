# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/dsl/version'

Gem::Specification.new do |spec|
  spec.name          = "elasticsearch-dsl"
  spec.version       = Elasticsearch::DSL::VERSION
  spec.authors       = ["Karel Minarik"]
  spec.email         = ["karel.minarik@elasticsearch.org"]
  spec.description   = %q{Elasticsearch Ruby DSL sugar (WIP)}
  spec.summary       = spec.description
  spec.homepage      = ""
  spec.license       = "Apache 2"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
