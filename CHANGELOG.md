**See the full release notes on the official documentation website: https://www.elastic.co/docs/release-notes/elasticsearch/clients/ruby**

# 9.1.3

## Elasticsearch API

Updates API code to the latest Elasticsearch 9.1 specification.

Updates `:bytes` and `:time` parameters in **Cat** endpoints:
* `cat.aliases`, `cat.allocation`, `cat.component_templates`, `cat.count`, `cat.fielddata`, `cat.health`, `cat.indices`, `cat.master`, `cat.ml_data_frame_analytics`, `cat.ml_datafeeds`, `cat.ml_jobs`, `cat.ml_trained_models`, `cat.nodeattrs`, `cat.nodes`, `cat.pending_tasks`, `cat.plugins`, `cat.recovery`, `cat.repositories`, `cat.segments`, `cat.shards`, `cat.snapshots`, `cat.tasks`, `cat.templates`, `cat.thread_pool`, `cat.transforms`:
  * Adds `:bytes` [String] - Sets the units for columns that contain a byte-size value
  * Adds `:time` [String] - Sets the units for columns that contain a time duration.
* `cat.allocation`, `cat.fielddata`, `cat.health`, `cat.indices`, `cat.ml_data_frame_analytics`, `cat.ml_jobs`, `cat.ml_trained_models`, `cat.nodes`, `cat.recovery`, `cat.segments`, `cat.shards`:
  * Removes `:bytes` parameter.
* `cat.indices`, `cat.ml_data_frame_analytics`, `cat.ml_datafeeds`, `cat.ml_jobs`, `cat.ml_trained_models`, `cat.nodes`, `cat.pending_tasks`, `cat.recovery`, `cat.shards`, `cat.snapshots`, `cat.tasks`, `cat.thread_pool`, `cat.transforms`:
  * Removes `:time` parameter.

Adds available parameters to experimental **Stream** namespace APIs. Updates `streams.logs_disable`, `streams.logs_enable`, `streams.status`.
* [Time] `:master_timeout` The period to wait for a connection to the master node.
* [Time] `:timeout` The period to wait for a response.
* [Boolean] `:error_trace` When set to `true` Elasticsearch will include the full stack trace of errors when they occur.
* [String, Array<String>] `:filter_path` Comma-separated list of filters in dot notation which reduce the response returned by Elasticsearch.
* [Boolean] `:human` When set to `true` will return statistics in a format suitable for humans.
* [Boolean] `:pretty` If set to `true` the returned JSON will be "pretty-formatted". Only use this option for debugging.

* `cat.segments` - New parameters:
  * [String, Array<String>] `:expand_wildcards` Type of index that wildcard expressions can match.
  * [Boolean] `:allow_no_indices` If `false`, the request returns an error if any wildcard expression, index alias, or _all value targets only.
  * [Boolean] `:ignore_throttled` If `true`, concrete, expanded or aliased indices are ignored when frozen.
  * [Boolean] `:ignore_unavailable` If true, missing or closed indices are not included in the response.
  * [Boolean] `:allow_closed` If true, allow closed indices to be returned in the response otherwise if false, keep the legacy behaviour
* `watcher.put_watch` - body is now required

# 9.1.2

* Fixes [2758](https://github.com/elastic/elasticsearch-ruby/issues/2758) - `msearch`, `bulk` and other NDJSON endpoints overriding headers for `content-type` and `accept`. [Pull Request](https://github.com/elastic/elasticsearch-ruby/pull/2759).
* Adds `transform.set_upgrade_mode`.
* Updates source code documentation from latest 9.1 Elasticsearch specification.

# 9.1.1

## Elasticsearch API

- Updates source code documentation to latest 9.1 specification.
- Adds inference.put_amazonsagemaker.

# 9.1.0

## Gem

Tested versions of Ruby for 9.1.0: Ruby (MRI) 3.2, 3.3, 3.4, `head`, JRuby 9.3, JRuby 9.4 and JRuby 10.

## Elasticsearch API

- Source code documentation and code has been updated with better formatting, updated links. It's also been updated to support common parameters and common cat parameters in APIs that support it (`error_trace`, `filter_path`, `human`, `pretty`). The API reference documentation can be generated with `rake doc`.

- `esql.async_query`, `esql.query` - adds `allow_partial_results` boolean parameter. If `true`, partial results will be returned if there are shard failures, but the query can continue to execute on other clusters and shards. If `false`, the query will fail if there are any failures. To override the default behavior, you can set the `esql.query.allow_partial_results` cluster setting to `false`. Server default: true.
- `indices.get_field_mapping` - removes `local` parameter.
- `synonyms.put_synonym`, `synonyms.put_synonym_rule` - add `refresh` boolean parameter. If `true`, the request will refresh the analyzers with the new synonym rule and wait for the new synonyms to be available before returning.

New APIs

- `esql.get_query` (Experimental) - Get a specific running ES|QL query information.
- `esql.list_queries` (Experimental) - Get running ES|QL queries information.
- `indices.delete_data_stream_options` - Removes the data stream options from a data stream.
- `indices.get_data_stream_options` - Get the data stream options configuration of one or more data streams.
- `indices.get_data_stream_settings` - Get setting information for one or more data streams.
- `indices.put_data_stream_options` - Update the data stream options of the specified data streams.
- `indices.put_data_stream_settings` - Update data stream settings.
- `indices.remove_block` - Remove an index block from an index.
- `inference.put_custom` - Create a custom inference endpoint.
- `inference.put_deepseek` - Create a DeepSeek inference endpoint.
- `snapshot.repository_verify_integrity` (Experimental) - Verify the integrity of the contents of a snapshot repository. NOTE: This API is intended for exploratory use by humans. You should expect the request parameters and the response format to vary in future versions.
- `streams.logs_disable` - Disable the Logs Streams feature for this cluster.
- `streams.logs_enable` - Enable the Logs Streams feature for this cluster.
- `streams.status` - Return the current status of the streams feature for each streams type.

# 9.0.2

- Udpates setting 'Accept' and 'Content-Type' headers as to not duplicate or overwrite user set headers [#2666](https://github.com/elastic/elasticsearch-ruby/pull/2666).

# 9.0.1

- The request headers were updated for Elasticsearch v9: `compatible-with=9` [#2660](https://github.com/elastic/elasticsearch-ruby/pull/2660).

# 9.0.0

Ruby 3.2 and up are tested and supported for 9.0. Older versions of Ruby have reached their end of life. We follow Ruby’s own maintenance policy and officially support all currently maintained versions per [Ruby Maintenance Branches](https://www.ruby-lang.org/en/downloads/branches/). The required Ruby version is set to `2.6` to keep compatiblity wit JRuby 9.3. However, we only test the code against currently supported Ruby versions.

## Gem

The size of both `elasticsearch` and `elasticsearch-api` gems is smaller than in previous versions. Some unnecessary files that were being included in the gem have now been removed. There has also been a lot of old code cleanup for the `9.x` branch.

## Elasticsearch Serverless

With the release of `9.0`, the [Elasticsearch Serverless](https://github.com/elastic/elasticsearch-serverless-ruby) client has been discontinued. You can use this client to build your Elasticsearch Serverless Ruby applications. The Elasticsearch Serverless API is fully supported. The CI build for Elasticsearch Ruby runs tests to ensure compatibility with Elasticsearch Serverless.

## Elasticsearch API

* The source code is now generated from [`elasticsearch-specification`](https://github.com/elastic/elasticsearch-specification/), so the API documentation is much more detailed and extensive. The value `Elasticsearch::ES_SPECIFICATION_COMMIT` is updated with the commit hash of elasticsearch-specification in which the code is based every time it's generated.
* The API code has been updated for compatibility with Elasticsearch API v 9.0.
* `indices.get_field_mapping` - `:fields` is a required parameter.
* `knn_search` - This API has been removed. It was only ever experimental and was deprecated in v`8.4`. It isn't supported in 9.0, and only works when the header `compatible-with=8` is set. The search API should be used for all knn queries.
* The functions in `utils.rb` that had names starting with double underscore have been renamed to remove these (e.g. `__listify` to `listify`).
* **Namespaces clean up**: The API namespaces are now generated dynamically based on the elasticsearch-specification. As such, some deprecated namespace files have been removed from the codebase:
  * The `rollup` namespace was removed. The rollup feature was never GA-ed, it has been deprecated since `8.11.0` in favor of downsampling.
  * The `data_frame_deprecated`, `remote` namespace files have been removed, no APIs were available.
  * The `shutdown` namespace was removed. It is designed for indirect use by ECE/ESS and ECK. Direct use is not supported.

## Scroll APIs need to send scroll_id in request body

Sending the `scroll_id` as a parameter has been deprecated since version 7.0.0. It needs to be specified in the request body for `clear_scroll` and `scroll`.

**Impact**<br>

Client code using `clear_scroll` or `scroll` APIs and the deprecated `scroll_id` as a parameter needs to be updated.

**Action**<br>

If you are using the `clear_scroll` or `scroll` APIs, and sending the `scroll_id` as a parameter, you need to update your code to send the `scroll_id` as part of the request body:
```ruby
# Before:
client.clear_scroll(scroll_id: scroll_id)
# Now:
client.clear_scroll(body: { scroll_id: scroll_id })

# Before:
client.scroll(scroll_id: scroll_id)
# Now:
client.scroll(body: { scroll_id: scroll_id })
```

## Testing

The gem `elasticsearch-api` migrated away from the Elasticsearch REST API tests and test runner in CI. We now run the [Elasticsearch Client tests](https://github.com/elastic/elasticsearch-clients-tests/) with the [Elasticsearch Tests Runner](https://github.com/elastic/es-test-runner-ruby). This gives us more control on what we're testing and makes the Buildkite build way faster in Pull Requests and scheduled builds.

## Fixes

* Some old rake tasks that were not being used have been removed. The rest were streamlined, the `es` namespace has been streamlined to make it easier to run Elasticsearch with Docker during development. The `docker` task namespace was merged into `es`.
* Elasticsearch's REST API Spec tests can still be ran with `rake test:deprecated:rest_api` and setting the corresponding value for the environment variable `TEST_SUITE` ('platinum' or 'free').
