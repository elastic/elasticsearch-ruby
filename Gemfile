# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

source 'https://rubygems.org'

gem 'elasticsearch-api',        :path => File.expand_path("../elasticsearch-api", __FILE__),        :require => false
gem 'elasticsearch-transport',  :path => File.expand_path("../elasticsearch-transport", __FILE__),  :require => false
gem 'elasticsearch-extensions', :path => File.expand_path("../elasticsearch-extensions", __FILE__), :require => false
gem 'elasticsearch',            :path => File.expand_path("../elasticsearch", __FILE__),            :require => false

gem "rake"
gem "pry"
gem "ansi"
gem "shoulda-context"
gem "mocha"
gem "yard"

if defined?(RUBY_VERSION) && RUBY_VERSION > '1.9'
  gem "ruby-prof"    unless defined?(JRUBY_VERSION) || defined?(Rubinius)
  gem "require-prof" unless defined?(JRUBY_VERSION) || defined?(Rubinius)
  gem "simplecov", '~> 0.17', '< 0.18'
  gem "simplecov-rcov"
  gem "cane"
end

if defined?(RUBY_VERSION) && RUBY_VERSION > '2.2'
  gem "test-unit", '~> 2'
end
