# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/api/version'

Gem::Specification.new do |s|
  s.name          = 'elasticsearch-api'
  s.version       = Elasticsearch::API::VERSION
  s.authors       = ['Karel Minarik']
  s.email         = ['karel.minarik@elasticsearch.org']
  s.summary       = 'Ruby API for Elasticsearch.'
  s.homepage      = 'https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/index.html'
  s.license       = 'Apache-2.0'
  s.metadata = {
    'homepage_uri' => 'https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/index.html',
    'changelog_uri' => 'https://github.com/elastic/elasticsearch-ruby/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/elastic/elasticsearch-ruby/tree/master/elasticsearch-api',
    'bug_tracker_uri' => 'https://github.com/elastic/elasticsearch-ruby/issues'
  }
  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.extra_rdoc_files  = [ 'README.md', 'LICENSE' ]
  s.rdoc_options      = [ '--charset=UTF-8' ]

  s.required_ruby_version = '>= 2.5'

  s.add_dependency 'multi_json'

  s.add_development_dependency 'ansi'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'elasticsearch'
  s.add_development_dependency 'elasticsearch-extensions'
  s.add_development_dependency 'elasticsearch-transport'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-reporters'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'shoulda-context'
  s.add_development_dependency 'yard'

  # Gems for testing integrations
  s.add_development_dependency 'jsonify'
  s.add_development_dependency 'hashie'

  s.add_development_dependency 'cane'
  s.add_development_dependency 'escape_utils' unless defined? JRUBY_VERSION
  s.add_development_dependency 'jbuilder'
  s.add_development_dependency 'require-prof' unless defined?(JRUBY_VERSION) || defined?(Rubinius)
  s.add_development_dependency 'ruby-prof' unless defined?(JRUBY_VERSION) || defined?(Rubinius)
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'simplecov-rcov'

  s.add_development_dependency 'test-unit', '~> 2'

  s.description = <<-DESC.gsub(/^    /, '')
    Ruby API for Elasticsearch. See the `elasticsearch` gem for full integration.
  DESC
end
