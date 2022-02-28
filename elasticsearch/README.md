# Elasticsearch

The `elasticsearch` library provides a Ruby client and API for [Elasticsearch](http://elasticsearch.com).

## Usage

This gem is a wrapper for two separate libraries:

* [`elastic-transport`](https://github.com/elastic/elastic-transport-ruby/), which provides a low-level Ruby client for connecting to [Elastic](http://elasticsearch.com) services.
* [`elasticsearch-api`](https://github.com/elasticsearch/elasticsearch-ruby/tree/main/elasticsearch-api), which provides a Ruby API for the Elasticsearch RESTful API.

Install the `elasticsearch` package and use the API directly:

```ruby
require 'elasticsearch'

client = Elasticsearch::Client.new(log: true)

client.cluster.health

client.transport.reload_connections!

client.search(q: 'test')

# etc.
```

Features overview:

* Pluggable logging and tracing
* Pluggable connection selection strategies (round-robin, random, custom)
* Pluggable transport implementation, customizable and extendable
* Pluggable serializer implementation
* Request retries and dead connections handling
* Node reloading (based on cluster state) on errors or on demand
* Consistent API support for the whole Elasticsearch API
* Extensive documentation and examples
* Emphasis on modularity and extendability of both the client and API libraries

(For integration with Ruby models and Rails applications, see the <https://github.com/elasticsearch/elasticsearch-rails> project.)

## Compatibility

We follow Ruby’s own maintenance policy and officially support all currently maintained versions per [Ruby Maintenance Branches](https://www.ruby-lang.org/en/downloads/branches/).

Language clients are forward compatible; meaning that clients support communicating with greater minor versions of Elasticsearch. Elastic language clients are also backwards compatible with lesser supported minor Elasticsearch versions.

## Installation

Install the package from [Rubygems](https://rubygems.org):

    gem install elasticsearch

To use an unreleased version, either add it to your `Gemfile` for [Bundler](http://gembundler.com):

    gem 'elasticsearch', git: 'git://github.com/elasticsearch/elasticsearch-ruby.git'

or install it from a source code checkout:

    git clone https://github.com/elasticsearch/elasticsearch-ruby.git
    cd elasticsearch-ruby/elasticsearch
    bundle install
    rake install

## Configuration

* [Identifying running tasks with X-Opaque-Id](#identifying-running-tasks-with-x-opaque-id)
* [Api Key Authentication](#api-key-authentication)

### Identifying running tasks with X-Opaque-Id

The X-Opaque-Id header allows to track certain calls, or associate certain tasks with the client that started them ([more on the Elasticsearch docs](https://www.elastic.co/guide/en/elasticsearch/reference/master/tasks.html#_identifying_running_tasks)). To use this feature, you need to set an id for `opaque_id` on the client on each request. Example:

```ruby
client = Elasticsearch::Client.new
client.search(index: 'myindex', q: 'title:test', opaque_id: '123456')
```
The search request will include the following HTTP Header:
```
X-Opaque-Id: 123456
```

You can also set a prefix for X-Opaque-Id when initializing the client. This will be prepended to the id you set before each request if you're using X-Opaque-Id. Example:
```ruby
client = Elastic::Transport::Client.new(opaque_id_prefix: 'eu-west1_')
client.search(index: 'myindex', q: 'title:test', opaque_id: '123456')
```
The request will include the following HTTP Header:
```
X-Opaque-Id: eu-west1_123456
```

### Api Key Authentication

You can use [**API Key authentication**](https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-create-api-key.html):

``` ruby
Elasticsearch::Client.new(
  host: host,
  transport_options: transport_options,
  api_key: credentials
)
```

Where credentials is either the base64 encoding of `id` and `api_key` joined by a colon or a hash with the `id` and `api_key`:

``` ruby
Elasticsearch::Client.new(
  host: host,
  transport_options: transport_options,
  api_key: {id: 'my_id', api_key: 'my_api_key'}
)
```

## API and Transport

Please refer to the specific library documentation for details:

* **Transport**:
   [[README]](https://github.com/elastic/elastic-transport-ruby#elastic-transport)
   [[Documentation]](https://rubydoc.info/github/elastic/elastic-transport-ruby/)

* **API**:
   [[README]](https://github.com/elastic/elasticsearch-ruby/tree/main/elasticsearch-api#elasticsearchapi)
   [[Documentation]](https://rubydoc.info/gems/elasticsearch-api)

## License

This software is licensed under the [Apache 2 license](./LICENSE).
