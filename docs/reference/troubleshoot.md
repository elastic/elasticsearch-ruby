---
navigation_title: Troubleshoot
mapped_pages:
  - https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/troubleshooting.html
---

# Troubleshoot: {{es}} Ruby client [troubleshooting]

Use the information in this section to troubleshoot common problems and find answers for frequently asked questions.


## Logging [ruby-ts-logging]

The client provides several options for logging that can help when things go wrong. Check out the extensive documentation on [Logging](advanced-config.md#logging).

If you are having trouble sending a request to {{es}} with the client, we suggest enabling `tracing` on the client and testing the cURL command that appears in your terminal:

```rb
client = Elasticsearch::Client.new(trace: true)
client.info
curl -X GET -H 'x-elastic-client-meta: es=8.9.0,rb=3.2.2,t=8.2.1,fd=2.7.4,nh=0.3.2, User-Agent: elastic-t
ransport-ruby/8.2.1 (RUBY_VERSION: 3.2.2; linux x86_64; Faraday v2.7.4), Content-Type: application/json' 'http://localhost:9200//?pretty'
```

Testing the cURL command can help find out if there’s a connection issue or if the issue is in the client code.


## Troubleshooting connection issues [ruby-ts-connection]

When working with multiple hosts, you might want to enable the `retry_on_failure` or `retry_on_status` options to perform a failed request on another node (refer to [Retrying on Failures](advanced-config.md#retry-failures)).

For optimal performance, use a HTTP library which supports persistent ("keep-alive") connections, such as [patron](https://github.com/toland/patron) or [Typhoeus](https://github.com/typhoeus/typhoeus). Require the library (`require 'patron'`) in your code for Faraday 1.x or the adapter (`require 'faraday/patron'`) for Faraday 2.x, and it will be automatically used.


## Adapter is not registered on Faraday [ruby-ts-adapter]

If you see a message like:

```
:adapter is not registered on Faraday::Adapter (Faraday::Error)
```

Then you might need to include the adapter library in your Gemfile and require it. You might get this error when migrating from Faraday v1 to Faraday v2. The main change when using Faraday v2 is all adapters, except for the default `net_http` one, have been moved out into separate gems. This means if you’re not using the default adapter and you migrate to Faraday v2, you’ll need to add the adapter gems to your Gemfile.

These are the gems required for the different adapters with Faraday 2, instead of the libraries on which they were based:

```ruby
# HTTPCLient
gem 'faraday-httpclient'

# NetHTTPPersistent
gem 'faraday-net_http_persistent'

# Patron
gem 'faraday-patron'

# Typhoeus
gem 'faraday-typhoeus'
```

Migrating to Faraday 2 solves the issue as long as the adapter is included (unless you’re using the default one `net-http`). Alternatively, you can lock the version of Faraday in your project to 1.x: `gem 'faraday', '~> 1'`

::::{important}
Migrating to Faraday v2 requires at least Ruby `2.6`. Faraday v1 requires `2.4`.
::::



## More Help [_more_help]

If you need more help, visit the [Elastic community forums](https://discuss.elastic.co/) and get answers from the experts in the community, including people from Elastic.

If you find a bug, have feedback, or find any other issue using the client, [submit an issue](https://github.com/elastic/elasticsearch-ruby/issues/new/choose) on GitHub.

