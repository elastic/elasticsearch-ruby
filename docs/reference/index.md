---
mapped_pages:
  https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/index.html
  - https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/ruby_client.html
---

# Ruby [ruby_client]

The `elasticsearch` [Rubygem](http://rubygems.org/gems/elasticsearch) provides a low-level client for communicating with an {{es}} cluster, fully compatible with other official clients.

More documentation is hosted in [Github](https://github.com/elastic/elasticsearch-ruby) and [RubyDoc](http://rubydoc.info/gems/elasticsearch).

Refer to the [*Getting started*](/reference/getting-started.md) page for a step-by-step quick start with the Ruby client.


## Features [_features]

* Pluggable logging and tracing
* Pluggable connection selection strategies (round-robin, random, custom)
* Pluggable transport implementation, customizable and extendable
* Pluggable serializer implementation
* Request retries and dead connections handling
* Node reloading (based on cluster state) on errors or on demand
* Modular API implementation
* 100% REST API coverage


## Transport and API [transport-api]

The `elasticsearch` gem combines two separate Rubygems:

* [`elastic-transport`](https://github.com/elastic/elastic-transport-ruby/) - provides an HTTP Ruby client for connecting to the {{es}} cluster. Refer to the documentation: [Transport](/reference/transport.md)
* [`elasticsearch-api`](https://github.com/elastic/elasticsearch-ruby/tree/main/elasticsearch-api) - provides a Ruby API for the {{es}} RESTful API.

Please consult their respective documentation for configuration options and technical details.

Notably, the documentation and comprehensive examples for all the API methods are contained in the source, and available online at [Rubydoc](http://rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions).

Keep in mind, that for optimal performance, you should use an HTTP library which supports persistent ("keep-alive") HTTP connections.

