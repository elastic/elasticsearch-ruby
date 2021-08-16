# Elasticsearch

This repository contains Ruby integrations for [Elasticsearch](https://www.elastic.co/products/elasticsearch).

[![6.x](https://github.com/elastic/elasticsearch-ruby/actions/workflows/6.x.yml/badge.svg?branch=6.x)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/6.x.yml) [![7.x](https://github.com/elastic/elasticsearch-ruby/workflows/7.x/badge.svg?branch=7.x)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/7.x.yml) [![master](https://github.com/elastic/elasticsearch-ruby/actions/workflows/master.yml/badge.svg?branch=master)](https://github.com/elastic/elasticsearch-ruby/actions/workflows/master.yml) [![Code Climate](https://codeclimate.com/github/elastic/elasticsearch-ruby/badges/gpa.svg)](https://codeclimate.com/github/elastic/elasticsearch-ruby)

The [`elasticsearch`](https://github.com/elasticsearch/elasticsearch-ruby/tree/master/elasticsearch)
library is a wrapper for two separate libraries:

* [`elasticsearch-transport`](https://github.com/elasticsearch/elasticsearch-ruby/tree/master/elasticsearch-transport),
  which provides a low-level Ruby client for connecting to an Elasticsearch cluster
* [`elasticsearch-api`](https://github.com/elasticsearch/elasticsearch-ruby/tree/master/elasticsearch-api),
  which provides a Ruby API for the Elasticsearch RESTful API

```ruby
require 'elasticsearch'

client = Elasticsearch::Client.new log: true

# if you specify Elasticsearch host
# client = Elasticsearch::Client.new url: 'http://localhost:9200', log: true

client.transport.reload_connections!

client.cluster.health

client.search q: 'test'

# etc.
```

Both of these libraries are extensively documented.
**Please read the [`elasticsearch-transport`](http://rubydoc.info/gems/elasticsearch-transport) and the [`elasticsearch-api`](http://rubydoc.info/gems/elasticsearch-api) documentation carefully.**

See also [`doc/examples`](https://github.com/elastic/elasticsearch-ruby/blob/master/docs/examples/README.md) for some practical examples.

**For optimal performance, you should use a HTTP library which supports persistent
("keep-alive") connections, e.g. [Patron](https://github.com/toland/patron) or [Typhoeus](https://github.com/typhoeus/typhoeus).** These libraries are not dependencies of the Elasticsearch gems. Ensure you define a dependency for a HTTP library in your own application.

This repository contains these additional Ruby libraries:

* [`elasticsearch-extensions`](https://github.com/elastic/elasticsearch-ruby/tree/master/elasticsearch-extensions), *deprecated*.
* [`elasticsearch-dsl`](https://github.com/elastic/elasticsearch-ruby/tree/master/elasticsearch-dsl),
  which provides a Ruby API for the [Elasticsearch Query DSL](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html),

Please see their respective READMEs for information and documentation.

For integration with Ruby models and Rails applications,
see the **[elasticsearch-rails](https://github.com/elasticsearch/elasticsearch-rails)** project.

## Compatibility

We follow Ruby’s own maintenance policy and officially support all currently maintained versions per [Ruby Maintenance Branches](https://www.ruby-lang.org/en/downloads/branches/).

Language clients are forward compatible; meaning that clients support communicating with greater minor versions of Elasticsearch. Elastic language clients are also backwards compatible with lesser supported minor Elasticsearch versions.

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

To work on the code, clone and bootstrap the project first:

```
git clone https://github.com/elasticsearch/elasticsearch-ruby.git
cd elasticsearch-ruby/
bundle exec rake setup
bundle exec rake bundle
```

This will clone the Elasticsearch repository into the project, and run `bundle install` in all subprojects. There are a few tasks to work with Elasticsearch. Use `rake -T` and look for the tasks in the `elasticsearch` namespace. You can build elasticsearch with `rake elasticsearch:build` after having ran setup.

To run tests, you need to start a testing cluster on port 9250, or provide a different one in the `TEST_CLUSTER_PORT` environment variable.

There's a Rake task to start a testing cluster in a Docker container:

`rake docker:start[version]` - E.g.: `rake docker:start[7.x-SNAPSHOT]`. To start the container with Platinum, pass it in as a parameter: `rake docker:start[7.x-SNAPSHOT,xpack]`.

To run tests against unreleased Elasticsearch versions, you can use the `rake elasticsearch:build` Rake task to build Elasticsearch from the cloned source (use `rake elasticsearch:update` to update the repository):

**Note:** If you have gems from the `elasticsearch` family installed system-wide, and want to use development ones, prepend the command with `bundle exec`.

```
rake elasticsearch:build
```

This is going to create the build in `./tmp/builds/`.

You can pass a branch name (tag, commit, ...) as the Rake task variable:

```
rake elasticsearch:build[origin/1.x]
```

To run all the tests in all the subprojects, use the Rake task:

```
time rake test:client
```

By default, tests will atempt to use `http://localhost:9200` as a test server. If you're using a different host/port, set the `TEST_ES_SERVER` environment variable, e.g.:

```
$ TEST_ES_SERVER='http://localhost:9250' be rake test:client
```

## License

This software is licensed under the [Apache 2 license](./LICENSE).
