# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/dsl/version'

Gem::Specification.new do |s|
  s.name          = 'elasticsearch-dsl'
  s.version       = Elasticsearch::DSL::VERSION
  s.authors       = ['Karel Minarik']
  s.email         = ['karel.minarik@elasticsearch.com']
  s.description   = %q{A Ruby DSL builder for Elasticsearch}
  s.summary       = s.description
  s.homepage      = 'https://github.com/elasticsearch/elasticsearch-ruby/tree/master/elasticsearch-dsl'
  s.license       = 'Apache-2.0'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.extra_rdoc_files  = [ 'README.md', 'LICENSE.txt' ]
  s.rdoc_options      = [ '--charset=UTF-8' ]

  s.required_ruby_version = '>= 2.5'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake', '~> 12.3'

  s.add_development_dependency 'elasticsearch'
  s.add_development_dependency 'elasticsearch-extensions'

  s.add_development_dependency 'cane'
  s.add_development_dependency 'minitest', '~> 5'
  s.add_development_dependency 'minitest-reporters', '~> 1'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'shoulda-context'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'test-unit', '~> 2'
  s.add_development_dependency 'yard'
end
