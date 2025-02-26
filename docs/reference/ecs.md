---
mapped_pages:
  - https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/ecs.html
---

# Elastic Common Schema (ECS) [ecs]

The [Elastic Common Schema (ECS)][Elastic Common Schema (ECS)](ecs://docs/reference/index.md)) is an open source format that defines a common set of fields to be used when storing event data like logs in Elasticsearch.

You can use the library [ecs-logging](https://github.com/elastic/ecs-logging-ruby) which is a set of libraries that enables you to transform your application logs to structured logs that comply with the ECS format.

Add this line to your application’s Gemfile:

```ruby
gem 'ecs-logging'
```

Then execute `bundle install`. Or install from the command line yourself:

```ruby
$ gem install ecs-logging
```

Then configure the client to use the logger:

```ruby
require 'ecs_logging/logger'
require 'elasticsearch'

logger = EcsLogging::Logger.new($stdout)
client = Elasticsearch::Client.new(logger: logger)
> client.info
{"@timestamp":"2022-07-12T05:31:18.590Z","log.level":"INFO","message":"GET http://localhost:9200/ [status:200, request:0.009s, query:n/a]","ecs.version":"1.4.0"}...
```

See [ECS Logging Ruby Reference](ecs-logging-ruby://docs/reference/index.md) for more information on how to configure the logger.

