---
navigation_title: "ES|QL"
mapped_pages:
  - https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/esql.html
---

# ES|QL in the Ruby client [esql]


This page helps you understand and use [ES|QL](docs-content://explore-analyze/query-filter/languages/esql.md) in the Ruby client.

There are two ways to use ES|QL in the Ruby client:

* Use the Elasticsearch [ES|QL API](https://www.elastic.co/docs/api/doc/elasticsearch/group/endpoint-esql) directly: This is the most flexible approach, but it’s also the most complex because you must handle results in their raw form. You can choose the precise format of results, such as JSON, CSV, or text.
* Use the Ruby ES|QL helper: The helper maps the raw response to an object that’s more readily usable by your application.

You can also try the [`elastic-esql`](#esql-ruby) gem, which helps you build ES|QL queries with Ruby.

## ES|QL API [esql-how-to]

The [ES|QL query API](https://www.elastic.co/docs/api/doc/elasticsearch/group/endpoint-esql) allows you to specify how results should be returned. You can choose a [response format](docs-content://explore-analyze/query-filter/languages/esql-rest.md#esql-rest-format) such as CSV, text, or JSON, then fine-tune it with parameters like column separators and locale.

By default, the `query` API returns a Hash response with `columns` and `values`:

$$$esql-query$$$

```ruby
query = <<ESQL
        FROM sample_data
        | EVAL duration_ms = ROUND(event.duration / 1000000.0, 1)
ESQL

response = client.esql.query(body: { query: query})
puts response

{"columns"=>[
  {"name"=>"@timestamp", "type"=>"date"},
  {"name"=>"client.ip", "type"=>"ip"},
  {"name"=>"event.duration", "type"=>"long"},
  {"name"=>"message", "type"=>"keyword"},
  {"name"=>"duration_ms", "type"=>"double"}
],
"values"=>[
  ["2023-10-23T12:15:03.360Z", "172.21.2.162", 3450233, "Connected to 10.1.0.3", 3.5],
  ["2023-10-23T12:27:28.948Z", "172.21.2.113", 2764889, "Connected to 10.1.0.2", 2.8],
  ["2023-10-23T13:33:34.937Z", "172.21.0.5", 1232382, "Disconnected", 1.2],
  ["2023-10-23T13:51:54.732Z", "172.21.3.15", 725448, "Connection error", 0.7],
  ["2023-10-23T13:52:55.015Z", "172.21.3.15", 8268153, "Connection error", 8.3],
  ["2023-10-23T13:53:55.832Z", "172.21.3.15", 5033755, "Connection error", 5.0],
  ["2023-10-23T13:55:01.543Z", "172.21.3.15", 1756467, "Connected to 10.1.0.1", 1.8]
]}
```


## ES|QL helper [esql-helper]

The ES|QL helper in the Ruby client provides an object response from the ES|QL query API, instead of the default JSON value.

To use the ES|QL helper, require it in your code:

```ruby
require 'elasticsearch/helpers/esql_helper'
```

The helper returns an array of hashes with the columns as keys and the respective values. Using the [preceding example](#esql-query), the helper returns the following:

```ruby
response = Elasticsearch::Helpers::ESQLHelper.query(client, query)

puts response

{"duration_ms"=>3.5, "message"=>"Connected to 10.1.0.3", "event.duration"=>3450233, "client.ip"=>"172.21.2.162", "@timestamp"=>"2023-10-23T12:15:03.360Z"}
{"duration_ms"=>2.8, "message"=>"Connected to 10.1.0.2", "event.duration"=>2764889, "client.ip"=>"172.21.2.113", "@timestamp"=>"2023-10-23T12:27:28.948Z"}
{"duration_ms"=>1.2, "message"=>"Disconnected", "event.duration"=>1232382, "client.ip"=>"172.21.0.5", "@timestamp"=>"2023-10-23T13:33:34.937Z"}
{"duration_ms"=>0.7, "message"=>"Connection error", "event.duration"=>725448, "client.ip"=>"172.21.3.15", "@timestamp"=>"2023-10-23T13:51:54.732Z"}
{"duration_ms"=>8.3, "message"=>"Connection error", "event.duration"=>8268153, "client.ip"=>"172.21.3.15", "@timestamp"=>"2023-10-23T13:52:55.015Z"}
```

Additionally, you can transform the data in the response by passing in a Hash of `column => Proc` values. You could use this for example to convert *@timestamp* into a DateTime object. Pass in a Hash to `query` as a `parser` defining a `Proc` for each value you’d like to parse:

```ruby
require 'elasticsearch/helpers/esql_helper'

parser = {
  '@timestamp' => Proc.new { |t| DateTime.parse(t) }
}
response = Elasticsearch::Helpers::ESQLHelper.query(client, query, parser: parser)
response.first['@timestamp']
# <DateTime: 2023-10-23T12:15:03+00:00 ((2460241j,44103s,360000000n),+0s,2299161j)>
```

You can pass in as many Procs as there are columns in the response. For example:

```ruby
parser = {
  '@timestamp' => Proc.new { |t| DateTime.parse(t) },
  'client.ip' => Proc.new { |i| IPAddr.new(i) },
  'event.duration' => Proc.new { |d| d.to_s }
}

response = Elasticsearch::Helpers::ESQLHelper.query(client, query, parser: parser)

puts response

{"duration_ms"=>3.5, "message"=>"Connected to 10.1.0.3", "event.duration"=>"3450233", "client.ip"=>#<IPAddr: IPv4:172.21.2.162/255.255.255.255>, "@timestamp"=>#<DateTime: 2023-10-23T12:15:03+00:00 ((2460241j,44103s,360000000n),+0s,2299161j)>}
{"duration_ms"=>2.8, "message"=>"Connected to 10.1.0.2", "event.duration"=>"2764889", "client.ip"=>#<IPAddr: IPv4:172.21.2.113/255.255.255.255>, "@timestamp"=>#<DateTime: 2023-10-23T12:27:28+00:00 ((2460241j,44848s,948000000n),+0s,2299161j)>}
{"duration_ms"=>1.2, "message"=>"Disconnected", "event.duration"=>"1232382", "client.ip"=>#<IPAddr: IPv4:172.21.0.5/255.255.255.255>, "@timestamp"=>#<DateTime: 2023-10-23T13:33:34+00:00 ((2460241j,48814s,937000000n),+0s,2299161j)>}
{"duration_ms"=>0.7, "message"=>"Connection error", "event.duration"=>"725448", "client.ip"=>#<IPAddr: IPv4:172.21.3.15/255.255.255.255>, "@timestamp"=>#<DateTime: 2023-10-23T13:51:54+00:00 ((2460241j,49914s,732000000n),+0s,2299161j)>}
{"duration_ms"=>8.3, "message"=>"Connection error", "event.duration"=>"8268153", "client.ip"=>#<IPAddr: IPv4:172.21.3.15/255.255.255.255>, "@timestamp"=>#<DateTime: 2023-10-23T13:52:55+00:00 ((2460241j,49975s,15000000n),+0s,2299161j)>}
```

## ES|QL Query Builder [esql-ruby]

The [`elastic-esql`](https://github.com/elastic/esql-ruby) gem helps you build queries for use with the [ES|QL query API](docs-content://explore-analyze/query-filter/languages/esql-rest.md). Here's an example:

```ruby
query = Elastic::ESQL.from('sample')
                     .sort('@timestamp')
                     .desc
                     .where('event_duration > 5000000')
                     .limit(3)
```

You can see the generated query with `.to_s`:

```ruby
query.to_s
=> "FROM sample | SORT @timestamp DESC | WHERE event_duration > 5000000 | LIMIT 3"
```

The `elastic-esql` library works independently of the {{es}} client, so you can use it alongside any client &mdash; not just `elasticsearch-ruby`.
For more information, see the gem [README](https://github.com/elastic/esql-ruby?tab=readme-ov-file#ruby-esql-query-builder).
