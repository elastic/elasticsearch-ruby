# Elasticsearch

This repository contains Ruby integrations for [Elasticsearch](http://elasticsearch.org):

* A client for connecting to an Elasticsearch cluster
* A Ruby API for the Elasticsearch's REST API

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

* [`elasticsearch-client`](https://github.com/elasticsearch/elasticsearch-ruby/tree/master/elasticsearch-client),
  which provides a Ruby client for connecting to an [Elasticsearch](http://elasticsearch.org) cluster
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

Please refer to the specific library documentation for detailed information and examples.

### Client

* [[README]](https://github.com/elasticsearch/elasticsearch-ruby/blob/master/elasticsearch-client/README.md)
* [[Documentation]](http://rubydoc.info/gems/elasticsearch-client/file/README.markdown)
* [[Test Suite]](https://github.com/elasticsearch/elasticsearch-ruby/blob/master/elasticsearch-client/test)

### API

* [[README]](https://github.com/elasticsearch/elasticsearch-ruby/blob/master/elasticsearch-api/README.md)
* [[Documentation]](http://rubydoc.info/gems/elasticsearch-api/file/README.markdown)
* [[Test Suite]](https://github.com/elasticsearch/elasticsearch-ruby/blob/master/elasticsearch-api/test)

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
