# Elasticsearch::DSL

The `elasticsearch-dsl` library provides a Ruby DSL builder for
the [Elasticsearch](http://elasticsearch.org) DSL.

The library is compatible with Ruby 1.9 or higher and Elasticsearch 1.0 and higher.

## Installation

Install the package from [Rubygems](https://rubygems.org):

    gem install elasticsearch-dsl

To use an unreleased version, either add it to your `Gemfile` for [Bundler](http://gembundler.com):

    gem 'elasticsearch-dsl', git: 'git://github.com/elasticsearch/elasticsearch-ruby.git'

or install it from a source code checkout:

    git clone https://github.com/elasticsearch/elasticsearch-ruby.git
    cd elasticsearch-ruby/elasticsearch-dsl
    bundle install
    rake install

## Usage

The library is designed as a group of standalone Ruby modules and DSL methods, which provide
an idiomatic way to build complex search definitions:

```ruby
require 'elasticsearch'
require 'elasticsearch/dsl'
include Elasticsearch::DSL

client = Elasticsearch::Client.new trace: true

definition = search do
  query do
    match title: 'test'
  end
end

definition.to_hash
# => { query: { match: { title: "test"} } }

client.search body: definition
# curl -X GET 'http://localhost:9200/test/_search?pretty' -d '{
#   "query":{
#     "match":{
#       "title":"test"
#     }
#   }
# }'
# ...
# => {"took"=>10, "hits"=> {"total"=>42, "hits"=> [...] } }
```

## License

This software is licensed under the Apache 2 license, quoted below.

    Copyright (c) 2014 Elasticsearch <http://www.elasticsearch.org>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
