# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/version'

Gem::Specification.new do |s|
  s.name          = 'elasticsearch'
  s.version       = Elasticsearch::VERSION
  s.authors       = ['Karel Minarik']
  s.email         = ['karel.minarik@elasticsearch.org']
  s.summary       = 'Ruby integrations for Elasticsearch'
  s.homepage      = 'https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/index.html'
  s.license       = 'Apache-2.0'
  s.metadata = {
    'homepage_uri' => 'https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/index.html',
    'changelog_uri' => 'https://github.com/elastic/elasticsearch-ruby/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/elastic/elasticsearch-ruby/tree/master',
    'bug_tracker_uri' => 'https://github.com/elastic/elasticsearch-ruby/issues'
  }
  s.files = `git ls-files`.split($/)
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.executables << 'elastic_ruby_console'
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']
  s.bindir = 'bin'

  s.extra_rdoc_files  = ['README.md', 'LICENSE.txt']
  s.rdoc_options      = ['--charset=UTF-8']

  s.required_ruby_version = '>= 2.5'

  s.add_dependency 'elasticsearch-transport', '8.0.0'
  s.add_dependency 'elasticsearch-api',       '8.0.0'
  s.add_development_dependency 'elasticsearch-extensions'

  s.add_development_dependency 'ansi'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'cane'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-reporters'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'require-prof' unless defined?(JRUBY_VERSION) || defined?(Rubinius)
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'ruby-prof' unless defined?(JRUBY_VERSION) || defined?(Rubinius)
  s.add_development_dependency 'shoulda-context'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'simplecov-rcov'
  s.add_development_dependency 'test-unit', '~> 2'
  s.add_development_dependency 'yard'

  s.description = <<-DESC.gsub(/^    /, '')
    Ruby integrations for Elasticsearch (client, API, etc.)
  DESC
end
