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
  s.homepage      = 'https://github.com/elasticsearch/elasticsearch-ruby/tree/master/elasticsearch-api'
  s.license       = 'Apache-2.0'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.extra_rdoc_files  = ['README.md', 'LICENSE.txt']
  s.rdoc_options      = ['--charset=UTF-8']

  s.required_ruby_version = '>= 2.4'

  s.add_dependency 'multi_json'
  s.add_development_dependency 'ansi'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'elasticsearch'
  s.add_development_dependency 'elasticsearch-extensions'
  s.add_development_dependency 'elasticsearch-transport'
  s.add_development_dependency 'minitest', '~> 4.0'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake', '~> 13'
  s.add_development_dependency 'shoulda-context'
  s.add_development_dependency 'turn'
  s.add_development_dependency 'yard'
  # Gems for testing integrations
  s.add_development_dependency 'cane'
  s.add_development_dependency 'escape_utils' unless defined? JRUBY_VERSION
  s.add_development_dependency 'hashie'
  s.add_development_dependency 'jbuilder'
  s.add_development_dependency 'jsonify'
  s.add_development_dependency 'simplecov', '~> 0.17', '< 0.18'
  s.add_development_dependency 'simplecov-rcov'
  s.add_development_dependency 'test-unit', '~> 2'
  unless defined?(JRUBY_VERSION) || defined?(Rubinius)
    s.add_development_dependency 'require-prof'
    s.add_development_dependency 'ruby-prof'
  end

  s.description = <<-DESC.gsub(/^    /, '')
    Ruby API for Elasticsearch. See the `elasticsearch` gem for full integration.
  DESC
end
