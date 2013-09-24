# Elasticsearch::Transport

**This library is part of the [`elasticsearch-ruby`](https://github.com/elasticsearch/elasticsearch-ruby/) package;
please refer to it, unless you want to use this library standalone.**

----

The `elasticsearch-transport` library provides a low-level Ruby client for connecting
to an [Elasticsearch](http://elasticsearch.org) cluster.

It handles connecting to multiple nodes in the cluster, rotating across connections,
logging and tracing requests and responses, maintaining failed connections,
discovering nodes in the cluster, and provides an abstraction for
data serialization and transport.

It does not handle calling the Elasticsearch API;
see the [`elasticsearch-api`](https://github.com/elasticsearch/elasticsearch-ruby/tree/master/elasticsearch-api) library.

The library is compatible with Ruby 1.8.7 or higher.

Features overview:

* Pluggable logging and tracing
* Plugabble connection selection strategies (round-robin, random, custom)
* Pluggable transport implementation, customizable and extendable
* Pluggable serializer implementation
* Request retries and dead connections handling
* Node reloading (based on cluster state) on errors or on demand

## Installation

Install the package from [Rubygems](https://rubygems.org):

    gem install elasticsearch-transport

To use an unreleased version, either add it to your `Gemfile` for [Bundler](http://gembundler.com):

    gem 'elasticsearch-transport', git: 'git://github.com/elasticsearch/elasticsearch-ruby.git'

or install it from a source code checkout:

    git clone https://github.com/elasticsearch/elasticsearch-ruby.git
    cd elasticsearch-ruby/elasticsearch-transport
    bundle install
    rake install

## Example Usage

In the simplest form, connect to Elasticsearch running on <http://localhost:9200>
without any configuration:

    require 'elasticsearch/transport'

    client = Elasticsearch::Client.new
    response = client.perform_request 'GET', '_cluster/health'
    # => #<Elasticsearch::Transport::Transport::Response:0x007fc5d506ce38 @status=200, @body={ ... } >

## Configuration

The client supports many configurations options for setting up and managing connections,
configuring logging, customizing the transport library, etc.

### Setting Hosts

To connect to a specific Elasticsearch host:

    Elasticsearch::Client.new host: 'search.myserver.com'

To connect to a host with specific port:

    Elasticsearch::Client.new host: 'myhost:8080'

To connect to multiple hosts:

    Elasticsearch::Client.new hosts: ['myhost1', 'myhost2']

Instead of Strings, you can pass host information as an array of Hashes:

    Elasticsearch::Client.new hosts: [ { host: 'myhost1', port: 8080 }, { host: 'myhost2', port: 8080 } ]

### Logging

To log requests and responses to standard output with the default logger (an instance of Ruby's {::Logger}) class):

    Elasticsearch::Client.new log: true

To trace requests and responses in the `curl` format:

    Elasticsearch::Client.new trace: true

You can customize the default logger or tracer:

    client.transport.logger.formatter = proc { |s, d, p, m| "#{s}: #{m}\n" }
    client.transport.logger.level = Logger::INFO

You can use a custom {::Logger} instance:

    Elasticsearch::Client.new logger: Logger.new(STDERR)

You can pass the client any conforming logger implementation:

    require 'logging' # https://github.com/TwP/logging/

    log = Logging.logger['elasticsearch']
    log.add_appenders Logging.appenders.stdout
    log.level = :info

    client = Elasticsearch::Client.new logger: log

### Randomizing Hosts

If you pass multiple hosts to the client, it rotates across them in a round-robin fashion, by default.
When the same client would be running in multiple processes (eg. in a Ruby web server such as Thin),
it might keep connecting to the same nodes "at once". To prevent this, you can randomize the hosts
collection on initialization and reloading:

    Elasticsearch::Client.new hosts: ['localhost:9200', 'localhost:9201'], randomize_hosts: true

### Retrying on Failures

When the client is initialized with multiple hosts, it makes sense to retry a failed request
on a different host:

    Elasticsearch::Client.new hosts: ['localhost:9200', 'localhost:9201'], retry_on_failure: true

You can specify how many times should the client retry the request before it raises an exception:

    Elasticsearch::Client.new hosts: ['localhost:9200', 'localhost:9201'], retry_on_failure: 5

### Reloading Hosts

Elasticsearch by default dynamically discovers new nodes in the cluster. You can leverage this
in the client, and periodically check for new nodes to spread the load.

To retrieve and use the information from the
[_Nodes Info API_](http://www.elasticsearch.org/guide/reference/api/admin-cluster-nodes-info/)
on every 10,000th request:

    Elasticsearch::Client.new hosts: ['localhost:9200', 'localhost:9201'], reload_connections: true

You can pass a specific number of requests after which the reloading should be performed:

    Elasticsearch::Client.new hosts: ['localhost:9200', 'localhost:9201'], reload_connections: 1_000

To reload connections on failures, use:

    Elasticsearch::Client.new hosts: ['localhost:9200', 'localhost:9201'], reload_on_failure: true

The reloading will timeout if not finished under 1 second by default. To change the setting:

    Elasticsearch::Client.new hosts: ['localhost:9200', 'localhost:9201'], sniffer_timeout: 3

### Connection Selector

By default, the client will rotate the connections in a round-robin fashion, using the
{Elasticsearch::Transport::Transport::Connections::Selector::RoundRobin} strategy.

You can implement your own strategy to customize the behaviour. For example,
let's have a "rack aware" strategy, which will prefer the nodes with a specific attribute,
and only when these are not be available, will use the rest:

    class RackIdSelector
      include Elasticsearch::Transport::Transport::Connections::Selector::Base

      def select(options={})
        connections.reject do |c|
          # Try selecting the nodes with a `rack_id:x1` attribute first
          c.host[:attributes] && c.host[:attributes][:rack_id] == 'x1'
        end.sample || connections.to_a.sample
      end
    end

    Elasticsearch::Client.new hosts: ['x1.search.org', 'x2.search.org'], selector_class: RackIdSelector

### Transport Implementations

By default, the client will use the [_Faraday_](https://rubygems.org/gems/faraday) HTTP library
as a transport implementation. You can configure the _Faraday_ instance, eg. to use a different
HTTP adapter or custom middleware, by passing a configuration block to the client constructor:

    require 'typhoeus'
    require 'typhoeus/adapters/faraday'

    configuration = lambda do |f|
      f.response :logger
      f.adapter  :typhoeus
    end

    transport = Elasticsearch::Transport::Transport::HTTP::Faraday.new \
      hosts: [ { host: 'localhost', port: '9200' } ],
      &configuration

    client = Elasticsearch::Client.new transport: transport

You can also use a [_Curb_](https://rubygems.org/gems/curb) based transport implementation:

    require 'curb'
    require 'elasticsearch/transport/transport/http/curb'

    client = Elasticsearch::Client.new transport_class: Elasticsearch::Transport::Transport::HTTP::Curb

It's possible to customize the _Curb_ instance by passing a block to the constructor as well:

    configuration = lambda { |c| c.verbose = true }

    transport = Elasticsearch::Transport::Transport::HTTP::Curb.new \
      hosts: [ { host: 'localhost', port: '9200' } ],
      &configuration

    client = Elasticsearch::Client.new transport: transport

You can write your own transport implementation easily, by including the
{Elasticsearch::Transport::Transport::Base} module, implementing the required contract,
and passing it to the client as the `transport_class` parameter. All the arguments
passed to client will be passed as the `:options` parameter to the transport constructor.

### Serializer Implementations

By default, the [MultiJSON](http://rubygems.org/gems/multi_json) library is used as the
serializer implementation, and it will pick up the "right" adapter based on gems available.

The serialization component is pluggable, though, so you can write your own by including the
{Elasticsearch::Transport::Transport::Serializer::Base} module, implementing the required contract,
and passing it to the client as the `serializer_class` or `serializer` parameter.

## Development and Community

For local development, clone the repository and run `bundle install`. See `rake -T` for a list of
available Rake tasks for running tests, generating documentation, starting a testing cluster, etc.

Bug fixes and features must be accompanying by unit tests. Integration tests are written in Ruby 1.9 syntax.

Github's pull requests and issues are used to send code contributions and bug reports.

## The Architecture

* {Elasticsearch::Transport::Client} is composed of {Elasticsearch::Transport::Transport}

* {Elasticsearch::Transport::Transport} is composed of {Elasticsearch::Transport::Transport::Connections},
  and an instance of logger, tracer, serializer and sniffer.

* Logger and tracer can be any object conforming to Ruby logging interface,
  ie. an instance of [`Logger`](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/logger/rdoc/Logger.html),
  [_log4r_](https://rubygems.org/gems/log4r), [_logging_](https://github.com/TwP/logging/), etc.

* The {Elasticsearch::Transport::Transport::Serializer::Base} implementations handle converting data for Elasticsearch
  (eg. to JSON). You can implement your own serializer.

* {Elasticsearch::Transport::Transport::Sniffer} allows to discover nodes in the cluster and use them as connections.

* {Elasticsearch::Transport::Transport::Connections::Collection} is composed of
  {Elasticsearch::Transport::Transport::Connections::Connection} instances and a selector instance.

* {Elasticsearch::Transport::Transport::Connections::Connection} contains the connection attributes such as hostname and port,
  as well as the concrete persistent "session" connected to a specific node.

* The {Elasticsearch::Transport::Transport::Connections::Selector::Base} implementations allow to choose connections
  from the pool, eg. in a round-robin or random fashion. You can implement your own selector strategy.

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
