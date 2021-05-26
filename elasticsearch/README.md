# Elasticsearch

The `elasticsearch` library provides a Ruby client and API for [Elasticsearch](http://elasticsearch.com).

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

(For integration with Ruby models and Rails applications,
see the <https://github.com/elasticsearch/elasticsearch-rails> project.)

## Compatibility

The Elasticsearch client for Ruby is compatible with Ruby 1.9 and higher.

The client's API is compatible with Elasticsearch's API versions from 0.90 till current,
just use a release matching major version of Elasticsearch.

| Ruby          |   | Elasticsearch |
|:-------------:|:-:| :-----------: |
| 0.90          | → | 0.90          |
| 1.x           | → | 1.x           |
| 2.x           | → | 2.x           |
| 5.x           | → | 5.x           |
| 6.x           | → | 6.x           |
| 7.x           | → | 7.x           |
| master        | → | master        |

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

## Usage

This library is a wrapper for two separate libraries:

* [`elasticsearch-transport`](https://github.com/elasticsearch/elasticsearch-ruby/tree/master/elasticsearch-transport),
  which provides a low-level Ruby client for connecting to an [Elasticsearch](http://elasticsearch.com) cluster
* [`elasticsearch-api`](https://github.com/elasticsearch/elasticsearch-ruby/tree/master/elasticsearch-api),
  which provides a Ruby API for the Elasticsearch RESTful API

Install the `elasticsearch` package and use the API directly:

```ruby
require 'elasticsearch'

client = Elasticsearch::Client.new log: true

client.cluster.health

client.transport.reload_connections!

client.search q: 'test'

# etc.
```

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