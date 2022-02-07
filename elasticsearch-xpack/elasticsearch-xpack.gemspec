# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/xpack/version'

Gem::Specification.new do |spec|
  spec.name          = 'elasticsearch-xpack'
  spec.version       = Elasticsearch::XPack::VERSION
  spec.authors       = ['Karel Minarik']
  spec.email         = ['karel@elastic.co']
  spec.summary       = 'Ruby integrations for the X-Pack extensions for Elasticsearch'
  spec.description   = 'Ruby integrations for the X-Pack extensions for Elasticsearch'
  spec.homepage      = 'https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/index.html'
  spec.license       = 'Apache-2.0'
  spec.metadata = {
    'homepage_uri' => 'https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/index.html',
    'changelog_uri' => 'https://github.com/elastic/elasticsearch-ruby/blob/6.x/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/elastic/elasticsearch-ruby/tree/6.x/elasticsearch-xpack',
    'bug_tracker_uri' => 'https://github.com/elastic/elasticsearch-ruby/issues'
  }
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'elasticsearch-api', '~> 6'

  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'ansi'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'elasticsearch', '~> 6'
  spec.add_development_dependency 'elasticsearch-extensions'
  spec.add_development_dependency 'elasticsearch-transport', '~> 6'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 13'
  spec.add_development_dependency 'ruby-prof' unless defined?(JRUBY_VERSION) || defined?(Rubinius)
  spec.add_development_dependency 'shoulda-context'
  spec.add_development_dependency 'yard'
end