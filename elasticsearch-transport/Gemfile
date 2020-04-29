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

# Specify your gem's dependencies in elasticsearch-transport.gemspec
gemspec

if File.exist? File.expand_path('../../elasticsearch-api/elasticsearch-api.gemspec', __FILE__)
  gem 'elasticsearch-api', path: File.expand_path('../../elasticsearch-api', __FILE__), require: false
end

if File.exist? File.expand_path('../../elasticsearch-extensions/elasticsearch-extensions.gemspec', __FILE__)
  gem 'elasticsearch-extensions', path: File.expand_path('../../elasticsearch-extensions', __FILE__), require: false
end

if File.exist? File.expand_path('../../elasticsearch/elasticsearch.gemspec', __FILE__)
  gem 'elasticsearch', path: File.expand_path('../../elasticsearch', __FILE__), require: false
end

group :development do
  gem 'rspec'
  if defined?(JRUBY_VERSION)
    gem 'pry-nav'
  else
    gem 'pry-byebug'
  end
end
