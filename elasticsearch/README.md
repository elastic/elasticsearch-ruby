# Elasticsearch

The `elasticsearch` library provides a Ruby client and API for [Elasticsearch](http://elasticsearch.com).

## Usage

This gem is a wrapper for two separate libraries:

* [`elasticsearch-transport`](https://github.com/elasticsearch/elasticsearch-ruby/tree/master/elasticsearch-transport), which provides a low-level Ruby client for connecting to [Elastic](http://elasticsearch.com) services.
* [`elasticsearch-api`](https://github.com/elasticsearch/elasticsearch-ruby/tree/master/elasticsearch-api), which provides a Ruby API for the Elasticsearch RESTful API.

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

The Elasticsearch client is compatible with currently maintained Ruby versions. See [Ruby Maintenance Branches](https://www.ruby-lang.org/en/downloads/branches/). We don't provide support to versions which have reached their end of life.

The client's API is compatible with Elasticsearch's API versions from 0.90 till current, just use a release matching major version of Elasticsearch.

|  Client version | Elasticsearch version | Supported | Tests                                                                                                                                                                          |
| :-------------: | :-------------------: | :-------: | :-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
|            0.90 |                  0.90 | :x:       |                                                                                                                                                                                 |
|             1.x |                   1.x | :x:       |                                                                                                                                                                                 |
|             2.x |                   2.x | :x:       |                                                                                                                                                                                 |
|             5.x |                   5.x | :x:       |                                                                                                                                                                                 |
|             6.x |                   6.x | :white_check_mark:       | [![6.x](https://github.com/elastic/elasticsearch-ruby/actions/workflows/6.x.yml/badge.svg?branch=6.x)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/6.x.yml)|
|             7.x |                   7.x | :white_check_mark:       | [![7.x](https://github.com/elastic/elasticsearch-ruby/actions/workflows/7.x.yml/badge.svg?branch=7.x)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/7.x.yml) |
|          master |                master | :x:       | [![master](https://github.com/elastic/elasticsearch-ruby/actions/workflows/master.yml/badge.svg?branch=master)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/master.yml)                                                                                                                                                                                |

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
   [[README]](https://github.com/elasticsearch/elasticsearch-ruby/blob/master/elasticsearch-transport/README.md)
   [[Documentation]](http://rubydoc.info/gems/elasticsearch-transport/file/README.markdown)

* **API**:
   [[README]](https://github.com/elasticsearch/elasticsearch-ruby/blob/master/elasticsearch-api/README.md)
   [[Documentation]](http://rubydoc.info/gems/elasticsearch-api/file/README.markdown)


## Development

You can run `rake -T` to check the test tasks. Use `COVERAGE=true` before running a test task to check the coverage with Simplecov.

## License

This software is licensed under the [Apache 2 license](./LICENSE).
