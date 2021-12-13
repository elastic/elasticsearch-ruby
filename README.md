# Elasticsearch

This repository contains Ruby integrations for [Elasticsearch](https://www.elastic.co/products/elasticsearch).

[![6.x](https://github.com/elastic/elasticsearch-ruby/actions/workflows/6.x.yml/badge.svg?branch=6.x)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/6.x.yml) [![7.x](https://github.com/elastic/elasticsearch-ruby/workflows/7.x/badge.svg?branch=7.x)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/7.x.yml) [![main](https://github.com/elastic/elasticsearch-ruby/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/main.yml) [![Code Climate](https://codeclimate.com/github/elastic/elasticsearch-ruby/badges/gpa.svg)](https://codeclimate.com/github/elastic/elasticsearch-ruby)

The [`elasticsearch`](https://github.com/elasticsearch/elasticsearch-ruby/tree/main/elasticsearch) library is a wrapper for two separate libraries:

* [`elastic-transport`](https://github.com/elastic/elastic-transport-ruby), which provides a low-level Ruby client for connecting to an Elasticsearch cluster
* [`elasticsearch-api`](https://github.com/elasticsearch/elasticsearch-ruby/tree/main/elasticsearch-api), which provides a Ruby API for the Elasticsearch RESTful API

Both of these libraries are extensively documented.
**Please read the [`elastic-transport`](https://rubydoc.info/github/elastic/elastic-transport-ruby/) and the [`elasticsearch-api`](http://rubydoc.info/gems/elasticsearch-api) documentation carefully.**

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

See also [`doc/examples`](https://github.com/elastic/elasticsearch-ruby/blob/main/docs/examples/) for some practical examples.

**For optimal performance, you should use a HTTP library which supports persistent
("keep-alive") connections, e.g. [Patron](https://github.com/toland/patron) or [Typhoeus](https://github.com/typhoeus/typhoeus).** These libraries are not dependencies of the Elasticsearch gems. Ensure you define a dependency for a HTTP library in your own application.

This repository contains these additional Ruby libraries:

* [`elasticsearch-extensions`](https://github.com/elastic/elasticsearch-ruby/tree/main/elasticsearch-extensions), *deprecated*.
* [`elasticsearch-dsl`](https://github.com/elastic/elasticsearch-ruby/tree/main/elasticsearch-dsl),
  which provides a Ruby API for the [Elasticsearch Query DSL](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html),

Please see their respective READMEs for information and documentation.

For integration with Ruby models and Rails applications,
see the **[elasticsearch-rails](https://github.com/elasticsearch/elasticsearch-rails)** project.

## Compatibility

We follow Ruby’s own maintenance policy and officially support all currently maintained versions per [Ruby Maintenance Branches](https://www.ruby-lang.org/en/downloads/branches/).

Language clients are forward compatible; meaning that clients support communicating with greater or equal minor versions of Elasticsearch. Elasticsearch language clients are only backwards compatible with default distributions and without guarantees made.

## Installation

Install the `elasticsearch` package from [Rubygems](https://rubygems.org/gems/elasticsearch):

    gem install elasticsearch

To use an unreleased version, either add it to your `Gemfile` for [Bundler](http://gembundler.com):

    gem 'elasticsearch', git: 'git://github.com/elasticsearch/elasticsearch-ruby.git'

or install it from a source code checkout:

    git clone https://github.com/elasticsearch/elasticsearch-ruby.git
    cd elasticsearch-ruby/elasticsearch
    bundle install
    rake install

## Development

See [CONTRIBUTING](https://github.com/elastic/elasticsearch-ruby/blob/main/CONTRIBUTING.md).

## License

This software is licensed under the [Apache 2 license](./LICENSE).
