# Elasticsearch
[![7.17](https://github.com/elastic/elasticsearch-ruby/actions/workflows/7.17.yml/badge.svg?branch=7.17)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/7.17.yml) [![8.14](https://github.com/elastic/elasticsearch-ruby/actions/workflows/tests.yml/badge.svg?branch=8.14)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/tests.yml) [![8.15](https://github.com/elastic/elasticsearch-ruby/actions/workflows/8.15.yml/badge.svg?branch=8.15)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/8.15.yml)  [![main](https://github.com/elastic/elasticsearch-ruby/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/main.yml) [![Build status](https://badge.buildkite.com/e50e66eb71bf6566a6479c8a29b25458f6781ee8e52cee8d96.svg)](https://buildkite.com/elastic/elasticsearch-ruby)

**[Download the latest version of Elasticsearch](https://www.elastic.co/downloads/elasticsearch)**
or
**[sign-up](https://cloud.elastic.co/registration?elektra=en-ess-sign-up-page)**
**for a free trial of Elastic Cloud**.

This repository contains the official [Elasticsearch](https://www.elastic.co/products/elasticsearch) Ruby client. The [`elasticsearch`](https://github.com/elasticsearch/elasticsearch-ruby/tree/main/elasticsearch) gem is a complete Elasticsearch client which uses two separate libraries:

* [`elastic-transport`](https://github.com/elastic/elastic-transport-ruby) - provides the low-level code for connecting to an Elasticsearch cluster.
* [`elasticsearch-api`](https://github.com/elasticsearch/elasticsearch-ruby/tree/main/elasticsearch-api) - provides a Ruby API for the Elasticsearch RESTful API.

## Documentation

Please refer to 
[the full documentation on elastic.co](https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/index.html) 
for comprehensive information.

Both `elastic-transport` and `elasticsearch-api` are documented. You can check 
the [`elastic-transport`](https://rubydoc.info/github/elastic/elastic-transport-ruby/) 
and the [`elasticsearch-api`](http://rubydoc.info/gems/elasticsearch-api) 
documentation at RubyDocs.

## Installation

```ruby
gem install elasticsearch
```

Refer to the [Installation section](https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/getting-started-ruby.html#_installation)
of the getting started documentation.

## Connecting

Refer to the [Connecting section](https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/getting-started-ruby.html#_connecting)
of the getting started documentation.

## Usage

```ruby
require 'elasticsearch'
client = Elasticsearch::Client.new(host: 'https://my-elasticsearch-host.example')
client.ping
client.search(q: 'test')
```

* [Creating an index](https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/getting-started-ruby.html#_creating_an_index)
* [Indexing a document](https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/getting-started-ruby.html#_indexing_documents)
* [Getting documents](https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/getting-started-ruby.html#_getting_documents)
* [Searching documents](https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/getting-started-ruby.html#_searching_documents)
* [Updating documents](https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/getting-started-ruby.html#_updating_documents)
* [Deleting documents](https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/getting-started-ruby.html#_deleting_documents)
* [Deleting an index](https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/getting-started-ruby.html#_deleting_an_index)

Refer to [the official documentation](https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/examples.html)
for examples of how to use the most frequently called APIs and 
[`doc/examples`](https://github.com/elastic/elasticsearch-ruby/blob/main/docs/examples/) 
for some practical examples.

**For optimal performance, you should use a HTTP library which supports persistent ("keep-alive") connections, e.g. [Patron](https://github.com/toland/patron) or [Typhoeus](https://github.com/typhoeus/typhoeus).** These libraries are not dependencies of the Elasticsearch gems. Ensure you define a dependency for a HTTP library in your own application.

Check out these other official Ruby libraries for working with Elasticsearch:

* [`elasticsearch-rails`](https://github.com/elasticsearch/elasticsearch-rails) - integration with Ruby models and Rails applications.
* [`elasticsearch-extensions`](https://github.com/elastic/elasticsearch-ruby/tree/7.17/elasticsearch-extensions), *deprecated*.
* [`elasticsearch-dsl`](https://github.com/elastic/elasticsearch-dsl-ruby) which provides a Ruby API for the [Elasticsearch Query DSL](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html).

Please see their respective READMEs for information and documentation.

## Compatibility

We follow Ruby’s own maintenance policy and officially support all currently maintained versions per [Ruby Maintenance Branches](https://www.ruby-lang.org/en/downloads/branches/).

Language clients are forward compatible; meaning that clients support communicating with greater or equal minor versions of Elasticsearch without breaking.
It does not mean that the client automatically supports new features of newer Elasticsearch versions; it is only possible after a release of a new client version.
For example, a 8.12 client version won't automatically support the new features of the 8.13 version of Elasticsearch, the 8.13 client version is required for that.
Elasticsearch language clients are only backwards compatible with default distributions and without guarantees made.

| Gem Version |   | Elasticsearch  Version | Supported |
|-------------|---|------------------------|-----------|
| 7.x         | → | 7.x                    | 7.17      |
| 8.x         | → | 8.x                    | 8.x       |
| main        | → | main                   |           |

## Development

See [CONTRIBUTING](https://github.com/elastic/elasticsearch-ruby/blob/main/CONTRIBUTING.md).

## License

This software is licensed under the [Apache 2 license](./LICENSE). See [NOTICE](./NOTICE).
