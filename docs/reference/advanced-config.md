---
mapped_pages:
  - https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/advanced-config.html
---

# Advanced configuration [advanced-config]

The client supports many configurations options for setting up and managing connections, configuring logging, customizing the transport library, and so on.


## Setting hosts [setting-hosts]

To connect to a specific {{es}} host:

```ruby
Elasticsearch::Client.new(host: 'search.myserver.com')
```

To connect to a host with specific port:

```ruby
Elasticsearch::Client.new(host: 'myhost:8080')
```

To connect to multiple hosts:

```ruby
Elasticsearch::Client.new(hosts: ['myhost1', 'myhost2'])
```

Instead of strings, you can pass host information as an array of Hashes:

```ruby
Elasticsearch::Client.new(hosts: [ { host: 'myhost1', port: 8080 }, { host: 'myhost2', port: 8080 } ])
```

::::{note}
When specifying multiple hosts, you might want to enable the `retry_on_failure` or `retry_on_status` options to perform a failed request on another node (refer to [Retrying on Failures](#retry-failures)).
::::


Common URL parts – scheme, HTTP authentication credentials, URL prefixes, and so on – are handled automatically:

```ruby
Elasticsearch::Client.new(url: 'https://username:password@api.server.org:4430/search')
```

You can pass multiple URLs separated by a comma:

```ruby
Elasticsearch::Client.new(urls: 'http://localhost:9200,http://localhost:9201')
```

Another way to configure URLs is to export the `ELASTICSEARCH_URL` variable.

The client is automatically going to use a round-robin algorithm across the hosts (unless you select or implement a different [Connection Selector](#connection-selector)).


## Default port [default-port]

The default port is `9200`. Specify a port for your host(s) if they differ from this default.

If you are using Elastic Cloud, the default port is port `9243`. You must supply your username and password separately, and optionally a port. Refer to [Elastic Cloud](/reference/connecting.md#auth-ec).


## Logging [logging]

To log requests and responses to standard output with the default logger (an instance of Ruby’s `::Logger` class), set the log argument to true:

```ruby
Elasticsearch::Client.new(log: true)
```

You can also use [`ecs-logging`](https://github.com/elastic/ecs-logging-ruby) which is a set of libraries that enables you to transform your application logs to structured logs that comply with the [Elastic Common Schema](ecs://reference/index.md). See [Elastic Common Schema (ECS)](/reference/ecs.md).

To trace requests and responses in the Curl format, set the `trace` argument:

```ruby
Elasticsearch::Client.new(trace: true)
```

You can customize the default logger or tracer:

```ruby
client.transport.logger.formatter = proc { |s, d, p, m| "#{s}: #{m}\n" }
client.transport.logger.level = Logger::INFO
```

Or, you can use a custom `::Logger` instance:

```ruby
Elasticsearch::Client.new(logger: Logger.new(STDERR))
```

You can pass the client any conforming logger implementation:

```ruby
require 'logging' # https://github.com/TwP/logging/

log = Logging.logger['elasticsearch']
log.add_appenders Logging.appenders.stdout
log.level = :info

client = Elasticsearch::Client.new(logger: log)
```


## APM integration [apm-integration]

This client integrates seamlessly with Elastic APM via the Elastic APM Agent. It automatically captures client requests if you are using the agent on your code. If you’re using `elastic-apm` v3.8.0 or up, you can set `capture_elasticsearch_queries` to `true` in `config/elastic_apm.yml` to also capture the body from requests in {{es}}. Refer to [this example](https://github.com/elastic/elasticsearch-ruby/tree/main/docs/examples/apm).


## Custom HTTP Headers [custom-http-headers]

You can set a custom HTTP header on the client’s initializer:

```ruby
client = Elasticsearch::Client.new(
  transport_options: {
    headers:
      {user_agent: "My App"}
  }
)
```

You can also pass in `headers` as a parameter to any of the API Endpoints to set custom headers for the request:

```ruby
client.search(index: 'myindex', q: 'title:test', headers: {user_agent: "My App"})
```


## Identifying running tasks with X-Opaque-Id [x-opaque-id]

The X-Opaque-Id header allows to track certain calls, or associate certain tasks with the client that started them (refer to [the documentation](https://www.elastic.co/docs/api/doc/elasticsearch/group/endpoint-tasks)). To use this feature, you need to set an id for `opaque_id` on the client on each request. Example:

```ruby
client = Elasticsearch::Client.new
client.search(index: 'myindex', q: 'title:test', opaque_id: '123456')
```

The search request includes the following HTTP Header:

```ruby
X-Opaque-Id: 123456
```

You can also set a prefix for X-Opaque-Id when initializing the client. This is prepended to the id you set before each request if you’re using X-Opaque-Id. Example:

```ruby
client = Elasticsearch::Client.new(opaque_id_prefix: 'eu-west1_')
client.search(index: 'myindex', q: 'title:test', opaque_id: '123456')
```

The request includes the following HTTP Header:

```ruby
X-Opaque-Id: eu-west1_123456
```


## Setting Timeouts [setting-timeouts]

For many operations in {{es}}, the default timeouts of HTTP libraries are too low. To increase the timeout, you can use the `request_timeout` parameter:

```ruby
Elasticsearch::Client.new(request_timeout: 5*60)
```

You can also use the `transport_options` argument documented below.


## Randomizing Hosts [randomizing-hosts]

If you pass multiple hosts to the client, it rotates across them in a round-robin fashion by default. When the same client would be running in multiple processes (for example, in a Ruby web server such as Thin), it might keep connecting to the same nodes "at once". To prevent this, you can randomize the hosts collection on initialization and reloading:

```ruby
Elasticsearch::Client.new(hosts: ['localhost:9200', 'localhost:9201'], randomize_hosts: true)
```


## Retrying on Failures [retry-failures]

When the client is initialized with multiple hosts, it makes sense to retry a failed request on a different host:

```ruby
Elasticsearch::Client.new(hosts: ['localhost:9200', 'localhost:9201'], retry_on_failure: true)
```

By default, the client does not retry the request. You can specify how many times to retry before it raises an exception by passing a number to `retry_on_failure`:

```ruby
 Elasticsearch::Client.new(hosts: ['localhost:9200', 'localhost:9201'], retry_on_failure: 5)
```

You can also use `retry_on_status` to retry when specific status codes are returned:

```ruby
Elasticsearch::Client.new(hosts: ['localhost:9200', 'localhost:9201'], retry_on_status: [502, 503])
```

These two parameters can also be used together:

```ruby
Elasticsearch::Client.new(hosts: ['localhost:9200', 'localhost:9201'], retry_on_status: [502, 503], retry_on_failure: 10)
```

You can also set a `delay_on_retry` value in milliseconds. This will add a delay to wait between retries:

```ruby
 Elasticsearch::Client.new(hosts: ['localhost:9200', 'localhost:9201'], retry_on_failure: 5, delay_on_retry: 1000)
```


## Reloading Hosts [reload-hosts]

{{es}} dynamically discovers new nodes in the cluster by default. You can leverage this in the client, and periodically check for new nodes to spread the load.

To retrieve and use the information from the [Nodes Info API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-nodes-info) on every 10,000th request:

```ruby
Elasticsearch::Client.new(hosts: ['localhost:9200', 'localhost:9201'], reload_connections: true)
```

You can pass a specific number of requests after which reloading should be performed:

```ruby
Elasticsearch::Client.new(hosts: ['localhost:9200', 'localhost:9201'], reload_connections: 1_000)
```

To reload connections on failures, use:

```ruby
Elasticsearch::Client.new(hosts: ['localhost:9200', 'localhost:9201'], reload_on_failure: true)
```

The reloading timeouts if not finished under 1 second by default. To change the setting:

```ruby
Elasticsearch::Client.new(hosts: ['localhost:9200', 'localhost:9201'], sniffer_timeout: 3)
```

::::{note}
When using reloading hosts ("sniffing") together with authentication, pass the scheme, user and password with the host info – or, for more clarity, in the `http` options:
::::


```ruby
Elasticsearch::Client.new(
  host: 'localhost:9200',
  http: { scheme: 'https', user: 'U', password: 'P' },
  reload_connections: true,
  reload_on_failure: true
)
```


## Connection Selector [connection-selector]

By default, the client rotates the connections in a round-robin fashion, using the `Elastic::Transport::Transport::Connections::Selector::RoundRobin` strategy.

You can implement your own strategy to customize the behaviour. For example, let’s have a "rack aware" strategy, which prefers the nodes with a specific attribute. The strategy uses the other nodes, only when these are unavailable:

```ruby
class RackIdSelector
  include Elastic::Transport::Transport::Connections::Selector::Base

  def select(options={})
    connections.select do |c|
      # Try selecting the nodes with a `rack_id:x1` attribute first
      c.host[:attributes] && c.host[:attributes][:rack_id] == 'x1'
    end.sample || connections.to_a.sample
  end
end

Elasticsearch::Client.new hosts: ['x1.search.org', 'x2.search.org'], selector_class: RackIdSelector
```


## Serializer Implementations [serializer-implementations]

By default, the [MultiJSON](https://rubygems.org/gems/multi_json) library is used as the serializer implementation, and it picks up the "right" adapter based on gems available.

The serialization component is pluggable, though, so you can write your own by including the `Elastic::Transport::Transport::Serializer::Base` module, implementing the required contract, and passing it to the client as the `serializer_class` or `serializer` parameter.


## Exception Handling [exception-handling]

The library defines a [number of exception classes](https://github.com/elastic/elastic-transport-ruby/blob/main/lib/elastic/transport/transport/errors.rb) for various client and server errors, as well as unsuccessful HTTP responses, making it possible to rescue specific exceptions with desired granularity.

The highest-level exception is `Elastic::Transport::Transport::Error` and is raised for any generic client or server errors.

`Elastic::Transport::Transport::ServerError` is raised for server errors only.

As an example for response-specific errors, a 404 response status raises an `Elastic::Transport::Transport::Errors::NotFound` exception.

Finally, `Elastic::Transport::Transport::SnifferTimeoutError` is raised when connection reloading ("sniffing") times out.

