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
