# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/version'

Gem::Specification.new do |s|
  s.name          = "elasticsearch"
  s.version       = Elasticsearch::VERSION
  s.authors       = ["Karel Minarik"]
  s.email         = ["karel.minarik@elasticsearch.org"]
  s.summary       = "Ruby integrations for Elasticsearch"
  s.homepage      = "http://github.com/elasticsearch/elasticsearch-ruby"
  s.license       = "Apache 2"

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.extra_rdoc_files  = [ "README.md", "LICENSE.txt" ]
  s.rdoc_options      = [ "--charset=UTF-8" ]

  s.add_dependency "elasticsearch-client", s.version
  s.add_dependency "elasticsearch-api",    s.version

  s.add_development_dependency "bundler", "> 1"
  s.add_development_dependency "rake"

  s.description = <<-DESC.gsub(/^    /, '')
    Ruby client, API/DSL and components for Elasticsearch.
    A "meta-gem" wrapping `elasticsearch-client` and `elasticsearch-api`.
  DESC
end
