# Elasticsearch
[![7.17](https://github.com/elastic/elasticsearch-ruby/actions/workflows/7.17.yml/badge.svg?branch=7.17)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/7.17.yml) [![8.1](https://github.com/elastic/elasticsearch-ruby/actions/workflows/8.1.yml/badge.svg?branch=8.1)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/8.1.yml) [![8.2](https://github.com/elastic/elasticsearch-ruby/actions/workflows/8.2.yml/badge.svg?branch=8.2)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/8.2.yml) [![8.3](https://github.com/elastic/elasticsearch-ruby/actions/workflows/8.3.yml/badge.svg?branch=8.3)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/8.3.yml) [![8.4](https://github.com/elastic/elasticsearch-ruby/actions/workflows/8.4.yml/badge.svg?branch=8.4)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/8.4.yml) [![8.5](https://github.com/elastic/elasticsearch-ruby/actions/workflows/8.5.yml/badge.svg?branch=8.5)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/8.5.yml) [![main](https://github.com/elastic/elasticsearch-ruby/actions/workflows/main.yml/badge.svg)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/main.yml)

This repository contains the official [Elasticsearch](https://www.elastic.co/products/elasticsearch) Ruby client. The [`elasticsearch`](https://github.com/elasticsearch/elasticsearch-ruby/tree/main/elasticsearch) gem is a complete Elasticsearch client which uses two separate libraries:

* [`elastic-transport`](https://github.com/elastic/elastic-transport-ruby) - provides the low-level code for connecting to an Elasticsearch cluster.
* [`elasticsearch-api`](https://github.com/elasticsearch/elasticsearch-ruby/tree/main/elasticsearch-api) - provides a Ruby API for the Elasticsearch RESTful API.

## Documentation

Please refer to [the full documentation on elastic.co](https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/index.html) for comprehensive information.

Both `elastic-transport` and `elasticsearch-api` are also documented. You can check the [`elastic-transport`](https://rubydoc.info/github/elastic/elastic-transport-ruby/) and the [`elasticsearch-api`](http://rubydoc.info/gems/elasticsearch-api) documentation at RubyDocs.

## Installation

Install the `elasticsearch` gem from [Rubygems](https://rubygems.org/gems/elasticsearch):

```
$ gem install elasticsearch
```

Or add it to your project's Gemfile:

```ruby
gem 'elasticsearch', 'VERSION'
```

## Usage example

```ruby
require 'elasticsearch'

client = Elasticsearch::Client.new(log: true)

# if you specify Elasticsearch host
# client = Elasticsearch::Client.new url: 'http://localhost:9200', log: true

client.transport.reload_connections!

client.cluster.health

client.search(q: 'test')

# etc.
```

See also [the official documentation](https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/examples.html) for examples of how to use the most frequently called APIs and [`doc/examples`](https://github.com/elastic/elasticsearch-ruby/blob/main/docs/examples/) for some practical examples.

**For optimal performance, you should use a HTTP library which supports persistent ("keep-alive") connections, e.g. [Patron](https://github.com/toland/patron) or [Typhoeus](https://github.com/typhoeus/typhoeus).** These libraries are not dependencies of the Elasticsearch gems. Ensure you define a dependency for a HTTP library in your own application.

Check out these other official Ruby libraries for working with Elasticsearch:

* [`elasticsearch-rails`](https://github.com/elasticsearch/elasticsearch-rails) - integration with Ruby models and Rails applications.
* [`elasticsearch-extensions`](https://github.com/elastic/elasticsearch-ruby/tree/7.17/elasticsearch-extensions), *deprecated*.
* [`elasticsearch-dsl`](https://github.com/elastic/elasticsearch-dsl-ruby) which provides a Ruby API for the [Elasticsearch Query DSL](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html).

Please see their respective READMEs for information and documentation.

## Compatibility

We follow Ruby’s own maintenance policy and officially support all currently maintained versions per [Ruby Maintenance Branches](https://www.ruby-lang.org/en/downloads/branches/).

Language clients are forward compatible; meaning that clients support communicating with greater or equal minor versions of Elasticsearch. Elasticsearch language clients are only backwards compatible with default distributions and without guarantees made.

## Development

See [CONTRIBUTING](https://github.com/elastic/elasticsearch-ruby/blob/main/CONTRIBUTING.md).

## License

This software is licensed under the [Apache 2 license](./LICENSE). See [NOTICE](./NOTICE).
