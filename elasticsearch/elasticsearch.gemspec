# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/version'

Gem::Specification.new do |s|
  s.name          = 'elasticsearch'
  s.version       = Elasticsearch::VERSION
  s.authors       = ['Karel Minarik']
  s.email         = ['karel.minarik@elasticsearch.org']
  s.summary       = 'Ruby integrations for Elasticsearch'
  s.homepage      = 'http://github.com/elasticsearch/elasticsearch-ruby'
  s.license       = 'Apache-2.0'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.extra_rdoc_files  = ['README.md', 'LICENSE.txt']
  s.rdoc_options      = ['--charset=UTF-8']

  s.required_ruby_version = '>= 2.4'
  s.add_dependency 'elasticsearch-api',       '6.8.1'
  s.add_dependency 'elasticsearch-transport', '6.8.1'

  s.add_development_dependency 'ansi'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'cane'
  s.add_development_dependency 'elasticsearch-extensions'
  s.add_development_dependency 'minitest', '~> 4.0'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake', '~> 13'
  s.add_development_dependency 'require-prof' unless defined?(JRUBY_VERSION) || defined?(Rubinius)
  s.add_development_dependency 'ruby-prof' unless defined?(JRUBY_VERSION) || defined?(Rubinius)
  s.add_development_dependency 'shoulda-context'
  s.add_development_dependency 'simplecov', '~> 0.17', '< 0.18'
  s.add_development_dependency 'simplecov-rcov'
  s.add_development_dependency 'test-unit', '~> 2'
  s.add_development_dependency 'turn'
  s.add_development_dependency 'yard'

  s.description = <<-DESC.gsub(/^    /, '')
    Ruby integrations for Elasticsearch (client, API, etc.)
  DESC
end
