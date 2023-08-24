# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/version'

Gem::Specification.new do |s|
  s.name          = 'elasticsearch'
  s.version       = Elasticsearch::VERSION
  s.authors       = ['Elastic Client Library Maintainers']
  s.email         = ['client-libs@elastic.co']
  s.summary       = 'Ruby integrations for Elasticsearch'
  s.homepage      = 'https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/index.html'
  s.license       = 'Apache-2.0'
  s.metadata = {
    'homepage_uri' => 'https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/index.html',
    'changelog_uri' => 'https://github.com/elastic/elasticsearch-ruby/blob/main/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/elastic/elasticsearch-ruby/tree/main',
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

  transport_version = ENV.fetch('TRANSPORT_VERSION', '8')
  if ['8', 'main'].include? transport_version
    s.add_dependency 'elastic-transport', '~> 8'
  else
    major_version = transport_version.gsub(/[0-9]+$/, '')
    next_minor_version = transport_version.gsub(/[0-9]+\./, '').to_i + 1
    s.add_dependency 'elastic-transport', "~> #{transport_version}", "< #{major_version}#{next_minor_version}"
  end

  s.add_dependency 'elasticsearch-api', '8.11.0'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'byebug' unless defined?(JRUBY_VERSION) || defined?(Rubinius)
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'require-prof' unless defined?(JRUBY_VERSION) || defined?(Rubinius)
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'ruby-prof' unless defined?(JRUBY_VERSION) || defined?(Rubinius)
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'yard'

  s.description = <<-DESC.gsub(/^    /, '')
    Ruby integrations for Elasticsearch (client, API, etc.)
  DESC
end
