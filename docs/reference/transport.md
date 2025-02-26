---
mapped_pages:
  - https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/transport.html
---

# Transport [transport]

The `elastic-transport` library provides a low-level Ruby client for connecting to an {{es}} cluster. It powers the [Elasticsearch Ruby](/reference/index.md) client.

When available, it handles connecting to multiple nodes in the cluster, rotating across connections, logging and tracing requests and responses, maintaining failed connections, discovering nodes in the cluster, and provides an abstraction for data serialization and transport.

It does not handle calling the {{es}} APIs.

This library uses [Faraday](https://github.com/lostisland/faraday) by default as the HTTP transport implementation. We test it with Faraday versions 1.x and 2.x.

For optimal performance, use a HTTP library which supports persistent ("keep-alive") connections, such as [patron](https://github.com/toland/patron) or [Typhoeus](https://github.com/typhoeus/typhoeus). Require the library (`require 'patron'`) in your code for Faraday 1.x or the adapter (`require 'faraday/patron'`) for Faraday 2.x, and it will be automatically used.

Currently these libraries are supported:

* [Patron](https://github.com/toland/patron)
* [Typhoeus](https://github.com/typhoeus/typhoeus)
* [HTTPClient](https://rubygems.org/gems/httpclient)
* [Net::HTTP::Persistent](https://rubygems.org/gems/net-http-persistent)

::::{note}
Use [Typhoeus](https://github.com/typhoeus/typhoeus) v1.4.0 or up since older versions are not compatible with Faraday 1.0.
::::


You can customize Faraday and implement your own HTTP transport. For detailed information, see the example configurations and more information [below](#transport-implementations).

Features overview:

* Pluggable logging and tracing
* Pluggable connection selection strategies (round-robin, random, custom)
* Pluggable transport implementation, customizable and extendable
* Pluggable serializer implementation
* Request retries and dead connections handling
* Node reloading (based on cluster state) on errors or on demand

Refer to [Advanced Configuration](/reference/advanced-config.md) to read about more configuration options.


## Installation [transport-install]

Install the package from [Rubygems](https://rubygems.org/):

```bash
gem install elastic-transport
```

To use an unreleased version, either add it to your `Gemfile` for [Bundler](http://gembundler.com/):

```bash
gem 'elastic-transport', git: 'git@github.com:elastic/elastic-transport-ruby.git'
```

or install it from a source code checkout:

```bash
git clone https://github.com/elastic/elastic-transport-ruby.git
cd elastic-transport
bundle install
rake install
```


## Example usage [transport-example-usage]

In the simplest form, connect to {{es}} running on [http://localhost:9200](http://localhost:9200) without any configuration:

```rb
require 'elastic/transport'

client = Elastic::Transport::Client.new
response = client.perform_request('GET', '_cluster/health')
# => #<Elastic::Transport::Transport::Response:0x007fc5d506ce38 @status=200, @body={ ... } >
```

Documentation is included as RDoc annotations in the source code and available online at [RubyDoc](http://rubydoc.info/gems/elastic-transport).


## Transport implementations [transport-implementations]

By default, the client uses the [Faraday](https://rubygems.org/gems/faraday) HTTP library as a transport implementation.

The Client auto-detects and uses an *adapter* for *Faraday* based on gems loaded in your code, preferring HTTP clients with support for persistent connections. Faraday 2 changed the way adapters are used ([read more here](https://github.com/lostisland/faraday/blob/main/UPGRADING.md#adapters-have-moved)). If you’re using Faraday 1.x, you can require the HTTP library. To use the [*Patron*](https://github.com/toland/patron) HTTP, for example, require it:

To use the [Patron](https://github.com/toland/patron) HTTP, for example, require it:

```rb
require 'patron'
```

If you’re using Faraday 2.x, you need to add the corresponding adapter gem to your Gemfile and require it after you require `faraday`:

```rb
# Gemfile
gem 'faraday-patron'

# Code
require 'faraday'
require 'faraday/patron'
```

Then, create a new client, and the Patron gem will be used as the "driver":

```rb
client = Elastic::Transport::Client.new

client.transport.connections.first.connection.builder.adapter
# => Faraday::Adapter::Patron

10.times do
  client.nodes.stats(metric: 'http')['nodes'].values.each do |n|
    puts "#{n['name']} : #{n['http']['total_opened']}"
  end
end

# => Stiletoo : 24
# => Stiletoo : 24
# => Stiletoo : 24
# => ...
```

To use a specific adapter for Faraday, pass it as the `adapter` argument:

```rb
client = Elastic::Client.new(adapter: :net_http_persistent)

client.transport.connections.first.connection.builder.handlers
# => [Faraday::Adapter::NetHttpPersistent]
```

If you see this error:

```rb
Faraday::Error: :net_http_persistent is not registered on Faraday::Adapter
```

When you’re using Faraday 2, you need to require the adapter before instantiating the client:

```rb
> client = Elasticsearch::Client.new(adapter: :net_http_persistent)
Faraday::Error: :net_http_persistent is not registered on Faraday::Adapter
> require 'faraday/net_http_persistent'
=> true
> client = Elasticsearch::Client.new(adapter: :net_http_persistent)
=> #<Elasticsearch::Client:0x00007eff2e7728e0
```

When using the Elasticsearch client, you can pass the `adapter` parameter when initializing the clients.

To pass options to the [`Faraday::Connection`](https://github.com/lostisland/faraday/blob/master/lib/faraday/connection.rb) constructor, use the `transport_options` key:

```rb
client = Elastic::Client.new(
  transport_options: {
    request: { open_timeout: 1 },
    headers: { user_agent:   'MyApp' },
    params:  { :format => 'yaml' },
    ssl:     { verify: false }
  }
)
```

To configure the Faraday instance directly, use a block:

```rb
require 'patron'

client = Elastic::Client.new(host: 'localhost', port: '9200') do |f|
  f.response :logger
  f.adapter  :patron
end
```

You can use any standard Faraday middleware and plugins in the configuration block.

You can also initialize the transport class yourself, and pass it to the client constructor as the `transport` argument. The Elasticsearch client accepts `:transport` parameter when initializing a client. So you can pass in a transport you’ve initialized with the following options:

```rb
require 'patron'

transport_configuration = lambda do |f|
  f.response :logger
  f.adapter  :patron
end

transport = Elastic::Transport::Transport::HTTP::Faraday.new(
  hosts: [ { host: 'localhost', port: '9200' } ],
  &transport_configuration
)

# Pass the transport to the client
#
client = Elastic::Client.new(transport: transport)
```

Instead of passing the transport to the constructor, you can inject it at run time:

```rb
# Set up the transport
#
faraday_configuration = lambda do |f|
  f.instance_variable_set :@ssl, { verify: false }
  f.adapter :excon
end

faraday_client = Elastic::Transport::Transport::HTTP::Faraday.new(
  hosts: [
    {
      host: 'my-protected-host',
      port: '443',
      user: 'USERNAME',
      password: 'PASSWORD',
      scheme: 'https'
    }
  ],
  &faraday_configuration
)

# Create a default client
#
client = Elastic::Client.new

# Inject the transport to the client
#
client.transport = faraday_client
```

You can also use a bundled [Curb](https://rubygems.org/gems/curb) based transport implementation:

```rb
require 'curb'
require 'elastic/transport/transport/http/curb'

client = Elastic::Client.new(transport_class: Elastic::Transport::Transport::HTTP::Curb)

client.transport.connections.first.connection
# => #<Curl::Easy http://localhost:9200/>
```

It’s possible to customize the Curb instance by passing a block to the constructor as well (in this case, as an inline block):

```rb
transport = Elastic::Transport::Transport::HTTP::Curb.new(
  hosts: [ { host: 'localhost', port: '9200' } ],
  & lambda { |c| c.verbose = true }
)

client = Elastic::Client.new(transport: transport)
```

You can write your own transport implementation by including the {Elastic::Transport::Transport::Base} module, implementing the required contract, and passing it to the client as the `transport_class` parameter – or by injecting it directly.


## Transport architecture [transport-architecture]

* `Elastic::Transport::Client` is composed of `Elastic::Transport::Transport`.
* `Elastic::Transport::Transport` is composed of `Elastic::Transport::Transport::Connections`, and an instance of logger, tracer, serializer and sniffer.
* Logger and tracer can be any object conforming to Ruby logging interface, for example, an instance of [`Logger`](https://ruby-doc.org/stdlib-1.9.3/libdoc/logger/rdoc/Logger.md), [log4r](https://rubygems.org/gems/log4r), [logging](https://github.com/TwP/logging/), and so on.
* The `Elastic::Transport::Transport::Serializer::Base` implementations handle converting data for {{es}} (for example, to JSON). You can implement your own serializer.
* `Elastic::Transport::Transport::Sniffer` allows to discover nodes in the cluster and use them as connections.
* `Elastic::Transport::Transport::Connections::Collection` is composed of `Elastic::Transport::Transport::Connections::Connection` instances and a selector instance.
* `Elastic::Transport::Transport::Connections::Connection` contains the connection attributes such as hostname and port, as well as the concrete persistent "session" connected to a specific node.
* The `Elastic::Transport::Transport::Connections::Selector::Base` implementations allow to choose connections from the pool, for example, in a round-robin or random fashion. You can implement your own selector strategy.
* The `Elastic::Transport::Transport::Response` object wraps the Elasticsearch JSON response. It provides `body`, `status`, and `headers` methods but you can treat it as a hash and access the keys directly.

