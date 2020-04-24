# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

source 'https://rubygems.org'

gem 'elasticsearch-api',        path: File.expand_path('../elasticsearch-api', __FILE__),        require: false
gem 'elasticsearch-transport',  path: File.expand_path('../elasticsearch-transport', __FILE__),  require: false
gem 'elasticsearch-extensions', path: File.expand_path('../elasticsearch-extensions', __FILE__), require: false
gem 'elasticsearch',            path: File.expand_path('../elasticsearch', __FILE__),            require: false

gem 'ansi'
gem 'cane'
gem 'mocha'
gem 'pry'
gem 'rake'
gem 'rubocop'
gem 'shoulda-context'
gem 'simplecov'
gem 'simplecov-rcov'
gem 'test-unit', '~> 2'
gem 'yard'
unless defined?(JRUBY_VERSION) || defined?(Rubinius)
  gem 'require-prof'
  gem 'ruby-prof'
end

group :development do
  gem 'rspec'
end
