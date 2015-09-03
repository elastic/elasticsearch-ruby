# Elasticsearch::API

**This library is part of the [`elasticsearch-ruby`](https://github.com/elasticsearch/elasticsearch-ruby/) package;
please refer to it, unless you want to use this library standalone.**

----

The `elasticsearch-api` library provides a Ruby implementation of
the [Elasticsearch](http://elasticsearch.org) REST API.

It does not provide an Elasticsearch client; see the
[`elasticsearch-transport`](https://github.com/elasticsearch/elasticsearch-ruby/tree/master/elasticsearch-transport)
library.

The library is compatible with Ruby 1.8.7 or higher.

The library is compatible with Elasticsearch 0.90 and 1.0 -- you have to install and use a matching version, though.

The 1.x versions and the master branch are compatible with **Elasticsearch 1.x** API.

To use the **Elasticsearch 0.90** API, install the **0.4.x** gem version or use the corresponding
[`0.4`](https://github.com/elasticsearch/elasticsearch-ruby/tree/0.4) branch.

## Installation

Install the package from [Rubygems](https://rubygems.org):

    gem install elasticsearch-api

To use an unreleased version, either add it to your `Gemfile` for [Bundler](http://gembundler.com):

    gem 'elasticsearch-api', git: 'git://github.com/elasticsearch/elasticsearch-ruby.git'

or install it from a source code checkout:

    git clone https://github.com/elasticsearch/elasticsearch-ruby.git
    cd elasticsearch-ruby/elasticsearch-api
    bundle install
    rake install

## Usage

The library is designed as a group of standalone Ruby modules, which can be mixed into a class
providing connection to Elasticsearch -- an Elasticsearch client.

### Usage with the `elasticsearch` gem

**When you use the client from the [`elasticsearch-ruby`](https://github.com/elasticsearch/elasticsearch-ruby/) package,
the library modules have been already included**, so you just call the API methods:

```ruby
require 'elasticsearch'

client = Elasticsearch::Client.new log: true

client.index  index: 'myindex', type: 'mytype', id: 1, body: { title: 'Test' }
# => {"_index"=>"myindex", ... "created"=>true}

client.search index: 'myindex', body: { query: { match: { title: 'test' } } }
# => {"took"=>2, ..., "hits"=>{"total":5, ...}}
```

Full documentation and examples are included as RDoc annotations in the source code
and available online at <http://rubydoc.info/gems/elasticsearch-api>.

### Usage with a custom client

When you want to mix the library into your own client, it must conform to a following _contract_:

* It responds to a `perform_request(method, path, params, body)` method,
* the method returns an object with `status`, `body` and `headers` methods.

A simple client could look like this:

```ruby
require 'multi_json'
require 'faraday'
require 'elasticsearch/api'

class MySimpleClient
  include Elasticsearch::API

  CONNECTION = ::Faraday::Connection.new url: 'http://localhost:9200'

  def perform_request(method, path, params, body)
    puts "--> #{method.upcase} #{path} #{params} #{body}"

    CONNECTION.run_request \
      method.downcase.to_sym,
      path,
      ( body ? MultiJson.dump(body): nil ),
      {'Content-Type' => 'application/json'}
  end
end

client = MySimpleClient.new

p client.cluster.health
# --> GET _cluster/health {}
# => "{"cluster_name":"elasticsearch" ... }"

p client.index index: 'myindex', type: 'mytype', id: 'custom', body: { title: "Indexing from my client" }
# --> PUT myindex/mytype/custom {} {:title=>"Indexing from my client"}
# => "{"ok":true, ... }"
```

### Using JSON Builders

Instead of passing the `:body` argument as a Ruby _Hash_, you can pass it as a _String_, potentially
taking advantage of JSON builders such as [JBuilder](https://github.com/rails/jbuilder) or
[Jsonify](https://github.com/bsiggelkow/jsonify):

```ruby
require 'jbuilder'

query = Jbuilder.encode do |json|
  json.query do
    json.match do
      json.title do
        json.query    'test 1'
        json.operator 'and'
      end
    end
  end
end

client.search index: 'myindex', body: query

# 2013-06-25 09:56:05 +0200: GET http://localhost:9200/myindex/_search [status:200, request:0.015s, query:0.011s]
# 2013-06-25 09:56:05 +0200: > {"query":{"match":{"title":{"query":"test 1","operator":"and"}}}}
# ...
# => {"took"=>21, ..., "hits"=>{"total"=>1, "hits"=>[{ "_source"=>{"title"=>"Test 1", ...}}]}}
```

### Using Hash Wrappers

For a more comfortable access to response properties, you may wrap it in one of the _Hash_ "object access"
wrappers, such as [`Hashie::Mash`](https://github.com/intridea/hashie):

```ruby
require 'hashie'

response = client.search index: 'myindex',
                         body: {
                           query: { match: { title: 'test' } },
                           aggregations: { tags: { terms: { field: 'tags' } } }
                         }

mash = Hashie::Mash.new response

mash.hits.hits.first._source.title
# => 'Test'

mash.aggregations.tags.terms.first
# => #<Hashie::Mash count=3 term="z">
```

## Development

To work on the code, clone and bootstrap the main repository first --
please see instructions in the main [README](../README.md#development).

To run tests, launch a testing cluster -- again, see instructions
in the main [README](../README.md#development) -- and use the Rake tasks:

```
time rake test:unit
time rake test:integration
```

Unit tests have to use Ruby 1.8 compatible syntax, integration tests
can use Ruby 2.x syntax and features.

## License

This software is licensed under the Apache 2 license, quoted below.

    Copyright (c) 2013 Elasticsearch <http://www.elasticsearch.org>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
