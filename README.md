# Elasticsearch

This repository contains Ruby integrations for [Elasticsearch](https://www.elastic.co/products/elasticsearch).

[![7.x](https://github.com/elastic/elasticsearch-ruby/workflows/7.x/badge.svg)](https://github.com/elastic/elasticsearch-ruby/actions) [![Code Climate](https://codeclimate.com/github/elastic/elasticsearch-ruby/badges/gpa.svg)](https://codeclimate.com/github/elastic/elasticsearch-ruby)

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

* [`elasticsearch-extensions`](https://github.com/elastic/elasticsearch-ruby/tree/master/elasticsearch-extensions),
   which provides a set of extensions to the base library,
* [`elasticsearch-dsl`](https://github.com/elastic/elasticsearch-ruby/tree/master/elasticsearch-dsl),
  which provides a Ruby API for the [Elasticsearch Query DSL](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html),
* [`elasticsearch-xpack`](https://github.com/elastic/elasticsearch-ruby/tree/master/elasticsearch-xpack),
  which provides a Ruby API for X-Pack APIs. This API is going to be merged into `elasticsearch-api` on v8.0.

Please see their respective READMEs for information and documentation.

For integration with Ruby models and Rails applications,
see the **[elasticsearch-rails](https://github.com/elasticsearch/elasticsearch-rails)** project.

## Compatibility

The Elasticsearch client is compatible with currently maintained Ruby versions. See [Ruby Maintenance Branches](https://www.ruby-lang.org/en/downloads/branches/). We don't provide support to versions which have reached their end of life.

The gem's version numbers follow Elasticsearch's major versions. The `master` branch is compatible with the Elasticsearch `master` branch, which is the next major version.

| Gem Version   |   | Elasticsearch |
|:-------------:|:-:| :-----------: |
| 0.90          | → | 0.90          |
| 1.x           | → | 1.x           |
| 2.x           | → | 2.x           |
| 5.x           | → | 5.x           |
| 6.x           | → | 6.x           |
| 7.x           | → | 7.x           |
| master        | → | master        |

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

This will clone the Elasticsearch repository into the project, and run `bundle install` in all subprojects.

To run tests, you need to start a testing cluster on port 9250, or provide a different one in the `TEST_CLUSTER_PORT` environment variable.

There's a Rake task to start the testing cluster:

```
rake test:cluster:start
```

You can configure the port, path to the startup script, number of nodes, and other settings with environment variables:

```
TEST_CLUSTER_COMMAND=./tmp/builds/elasticsearch-7.10.0-SNAPSHOT/bin/elasticsearch \
TEST_CLUSTER_PORT=9250 \
TEST_CLUSTER_NODES=2 \
TEST_CLUSTER_NAME=my_cluster \
ES_JAVA_OPTS='-Xms500m -Xmx500m' \
TEST_CLUSTER_TIMEOUT=120 \
rake test:cluster:start
```

You can stop the cluster with a rake task, passing in the `TEST_CLUSTER_COMMAND` variable:

```
TEST_CLUSTER_COMMAND=./tmp/builds/elasticsearch-7.10.0-SNAPSHOT/bin/elasticsearch \
rake test:cluster:stop
```

To run tests against unreleased Elasticsearch versions, you can use the `rake elasticsearch:build` Rake task to build Elasticsearch from the cloned source (use `rake elasticsearch:update` to update the repository):

**Note:** If you have gems from the `elasticsearch` family installed system-wide, and want to use development ones, prepend the command with `bundle exec`.

```
rake elasticsearch:build
```

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
