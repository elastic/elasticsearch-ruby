# Elasticsearch

This repository contains Ruby integrations for [Elasticsearch](http://elasticsearch.org):

* a client for connecting to an Elasticsearch cluster,
* a Ruby API for the Elasticsearch's REST API,
* various extensions and utilities.

For integration with Ruby models and Rails applications,
see the <https://github.com/elasticsearch/elasticsearch-rails> project.

## Compatibility

The libraries are compatible with Ruby 1.8.7 and higher.

The library is compatible with Elasticsearch 0.90 and 1.0 -- you have to install and use a matching version, though.

The 1.x versions and the master branch are compatible with **Elasticsearch 1.x** API.

To use the **Elasticsearch 0.90** API, install the **0.4.x** gem version or use the corresponding
[`0.4`](https://github.com/elasticsearch/elasticsearch-ruby/tree/0.4) branch.

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

## Usage

The [`elasticsearch`](https://github.com/elasticsearch/elasticsearch-ruby/tree/master/elasticsearch)
library is a wrapper for two separate libraries:

* [`elasticsearch-transport`](https://github.com/elasticsearch/elasticsearch-ruby/tree/master/elasticsearch-transport),
  which provides a low-level Ruby client for connecting to an [Elasticsearch](http://elasticsearch.org) cluster
* [`elasticsearch-api`](https://github.com/elasticsearch/elasticsearch-ruby/tree/master/elasticsearch-api),
  which provides a Ruby API for the Elasticsearch RESTful API

```ruby
require 'elasticsearch'

client = Elasticsearch::Client.new log: true

client.transport.reload_connections!

client.cluster.health

client.search q: 'test'

# etc.
```

Both of these libraries are extensively documented.
**Please read the [`elasticsearch-transport`](http://rubydoc.info/gems/elasticsearch-transport)
and the [`elasticsearch-api`](http://rubydoc.info/gems/elasticsearch-api) documentation carefully.**

Keep in mind, that for optimal performance, you should use a HTTP library which supports persistent
("keep-alive") connections, e.g. [Patron](https://github.com/toland/patron).
Just `require 'patron'` in your code, and the library will automatically use it as the Faraday adapter.

### Transport

* [README](https://github.com/elasticsearch/elasticsearch-ruby/blob/master/elasticsearch-transport/README.md)
* [Documentation](http://rubydoc.info/gems/elasticsearch-transport)
* [Test Suite](https://github.com/elasticsearch/elasticsearch-ruby/blob/master/elasticsearch-transport/test)

### API

* [README](https://github.com/elasticsearch/elasticsearch-ruby/blob/master/elasticsearch-api/README.md)
* [Documentation](http://rubydoc.info/gems/elasticsearch-api/)
* [Test Suite](https://github.com/elasticsearch/elasticsearch-ruby/blob/master/elasticsearch-api/test)

### Extensions

* [README](https://github.com/elasticsearch/elasticsearch-ruby/blob/master/elasticsearch-extensions/README.md)
* [Documentation](http://rubydoc.info/gems/elasticsearch-extensions/)
* [Test Suite](https://github.com/elasticsearch/elasticsearch-ruby/blob/master/elasticsearch-extensions/test)

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
