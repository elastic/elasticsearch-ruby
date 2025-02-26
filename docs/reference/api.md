---
mapped_pages:
  - https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/api.html
---

# Elasticsearch API [api]

The `elasticsearch-api` library provides a Ruby implementation of the [Elasticsearch](https://www.elastic.co/elastic-stack/) REST API.


## Installation [api-install]

Install the package from [Rubygems](https://rubygems.org):

```bash
gem install elasticsearch-api
```

To use an unreleased version, either add it to your `Gemfile` for [Bundler](https://bundler.io/):

```bash
gem 'elasticsearch-api', git: 'git://github.com/elasticsearch/elasticsearch-ruby.git'
```

or install it from a source code checkout:

```bash
git clone https://github.com/elasticsearch/elasticsearch-ruby.git
cd elasticsearch-ruby/elasticsearch-api
bundle install
rake install
```


## Example usage [api-example-usage]

The library is designed as a group of standalone Ruby modules, which can be mixed into a class providing connection to Elasticsearch — an Elasticsearch client.


### Usage with the `elasticsearch` gem [_usage_with_the_elasticsearch_gem]

**When you use the client from the [`elasticsearch-ruby`](https://github.com/elasticsearch/elasticsearch-ruby) client, the library modules have been already included**, so you just call the API methods.

The response will be an `Elasticsearch::API::Response` object which wraps an `Elasticsearch::Transport::Transport::Response` object. It provides `body`, `status` and `headers` methods, but you can treat is as a hash and access the keys directly.

```rb
require 'elasticsearch'

client = Elasticsearch::Client.new

>response = client.index(index: 'myindex', id: 1, body: { title: 'Test' })
=> #<Elasticsearch::API::Response:0x00007fc9564b4980
 @response=
  #<Elastic::Transport::Transport::Response:0x00007fc9564b4ac0
   @body=
    {"_index"=>"myindex",
     "_id"=>"1",
     "_version"=>2,
     "result"=>"updated",
     "_shards"=>{"total"=>1, "successful"=>1, "failed"=>0},
     "_seq_no"=>1,
     "_primary_term"=>1},
   @headers=
    {"x-elastic-product"=>"Elasticsearch",
     "content-type"=>"application/json",
     "content-encoding"=>"gzip",
     "content-length"=>"130"},
   @status=200>>

> response['result']
=> "updated"

client.search(index: 'myindex', body: { query: { match: { title: 'test' } } })
# => => #<Elasticsearch::API::Response:0x00007fc95674a550
 @response=
  #<Elastic::Transport::Transport::Response:0x00007fc95674a5c8
   @body=
    {"took"=>223,
     "timed_out"=>false,
     "_shards"=>{"total"=>2, "successful"=>2, "skipped"=>0, "failed"=>0},
     "hits"=>
      {"total"=>{"value"=>1, "relation"=>"eq"},
       "max_score"=>0.2876821,
       "hits"=>[{"_index"=>"myindex", "_id"=>"1", "_score"=>0.2876821, "_source"=>{"title"=>"Test"}}]}},
   @headers=
    {"x-elastic-product"=>"Elasticsearch",
     "content-type"=>"application/json",
     "content-encoding"=>"gzip",
     "content-length"=>"188"},
   @status=200>>
```

Full documentation and examples are included as RDoc annotations in the source code and available online at [http://rubydoc.info/gems/elasticsearch-api](http://rubydoc.info/gems/elasticsearch-api).


### Usage with a custom client [_usage_with_a_custom_client]

When you want to mix the library with your own client, it must conform to the following *contract*:

* It responds to a `perform_request(method, path, params, body, headers)` method,
* the method returns an object with `status`, `body` and `headers` methods.

A simple client could look like this (*with a dependency on `active_support` to parse the query params*):

```rb
require 'multi_json'
require 'faraday'
require 'elasticsearch/api'

class MySimpleClient
  include Elasticsearch::API

  CONNECTION = ::Faraday::Connection.new(url: 'http://localhost:9200')

  def perform_request(method, path, params, body, headers = nil)
    puts "--> #{method.upcase} #{path} #{params} #{body} #{headers}"

    CONNECTION.run_request \
      method.downcase.to_sym,
      path_with_params(path, params),
      ( body ? MultiJson.dump(body): nil ),
      {'Content-Type' => 'application/json'}
  end

  private

  def path_with_params(path, params)
    return path if params.blank?

    case params
    when String
      "#{path}?#{params}"
    when Hash
      "#{path}?#{URI.encode_www_form(params)}"
    else
      raise ArgumentError, "Cannot parse params: '#{params}'"
    end
  end
end

client = MySimpleClient.new

p client.cluster.health
# --> GET _cluster/health {}
# => "{"cluster_name":"elasticsearch" ... }"

p client.index(index: 'myindex', id: 'custom', body: { title: "Indexing from my client" })
# --> PUT myindex/mytype/custom {} {:title=>"Indexing from my client"}
# => "{"ok":true, ... }"
```


### Using JSON Builders [_using_json_builders]

Instead of passing the `:body` argument as a Ruby *Hash*, you can pass it as a *String*, potentially taking advantage of JSON builders such as [JBuilder](https://github.com/rails/jbuilder) or [Jsonify](https://github.com/bsiggelkow/jsonify):

```rb
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

client.search(index: 'myindex', body: query)

# 2013-06-25 09:56:05 +0200: GET http://localhost:9200/myindex/_search [status:200, request:0.015s, query:0.011s]
# 2013-06-25 09:56:05 +0200: > {"query":{"match":{"title":{"query":"test 1","operator":"and"}}}}
# ...
# => {"took"=>21, ..., "hits"=>{"total"=>1, "hits"=>[{ "_source"=>{"title"=>"Test 1", ...}}]}}
```


### Using Hash Wrappers [_using_hash_wrappers]

For a more comfortable access to response properties, you may wrap it in one of the *Hash* "object access" wrappers, such as [`Hashie::Mash`](https://github.com/intridea/hashie):

```rb
require 'hashie'

response = client.search(
  index: 'myindex',
  body: {
    query: { match: { title: 'test' } },
    aggregations: { tags: { terms: { field: 'tags' } } }
  }
)

mash = Hashie::Mash.new(response)

mash.hits.hits.first._source.title
# => 'Test'
```


### Using a Custom JSON Serializer [_using_a_custom_json_serializer]

The library uses the [MultiJson](https://rubygems.org/gems/multi_json/) gem by default but allows you to set a custom JSON library, provided it uses the standard `load/dump` interface:

```rb
Elasticsearch::API.settings[:serializer] = JrJackson::Json
Elasticsearch::API.serializer.dump({foo: 'bar'})
# => {"foo":"bar"}
```
