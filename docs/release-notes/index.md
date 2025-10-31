---
navigation_title: "Elasticsearch Ruby Client"
mapped_pages:
  - https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/release_notes.html
---

# Elasticsearch Ruby Client release notes [elasticsearch-ruby-client-release-notes]

Review the changes, fixes, and more in each version of Elasticsearch Ruby Client.

To check for security updates, go to [Security announcements for the Elastic stack](https://discuss.elastic.co/c/announcements/security-announcements/31).

% Release notes include only features, enhancements, and fixes. Add breaking changes, deprecations, and known issues to the applicable release notes sections.

% ## version.next [elasticsearch-ruby-client-next-release-notes]

% ### Features and enhancements [elasticsearch-ruby-client-next-features-enhancements]
% *

% ### Fixes [elasticsearch-ruby-client-next-fixes]
% *

## 9.2.0 [elasticsearch-ruby-client-9.2.0-release-notes]

Check out [breaking changes](breaking-changes.md#elasticsearch-ruby-client-9.2.0-breaking-changes) for this update.

### Features and enhancements [elasticsearch-ruby-client-9.2.0-features-enhancements]

#### Gem

* Tested versions of Ruby for 9.2.0: Ruby (MRI) 3.2, 3.3, 3.4, head, JRuby 9.3, JRuby 9.4 and JRuby 10.
* Cleaned up deprecated code for code generation in `elasticsearch-api/utils`.

#### Elasticsearch API

Code updated to the latest Elasticsearch 9.2 specification.

##### API Updates

* `async_search.submit`, `cat.count`, `count`, `eql.search`, `field_caps`, `indices.resolve_index`. `msearch`, `msearch_template`, `open_point_in_time`, `search`, `search_mvt`, `search_template`, `sql.query` - New parameter:
  * `:project_routing`. Specifies a subset of projects to target for the search using project metadata tags in a subset of Lucene query syntax. Supported in serverless only.
* `cluster.allocation_explain` - New parameters:
  * [String] `:index` The name of the index that you would like an explanation for.
  * [Integer] `:shard` An identifier for the shard that you would like an explanation for.
  * [Boolean] `:primary` If true, returns an explanation for the primary shard for the specified shard ID.
  * [String] `:current_node` Explain a shard only if it is currently located on the specified node name or node ID.
* `get` - New parameter:
  * [Boolean] `:_source_exclude_vectors` Whether vectors should be excluded from _source
* `indices.resolve_index` - New parameter:
  * [String, Array<String>] `:mode` Filter indices by index mode - standard, lookup, time_series, etc. Comma-separated list of IndexMode. Empty means no filter.
* `search` - New parameter:
  * [Boolean] `:_source_exclude_vectors` Whether vectors should be excluded from _source.
* `security.update_settings` - New parameter:
  *  [String] `:merge_type` The mapping merge type if mapping overrides are being provided in mapping_addition.

##### New APIs

* `indices.get_data_stream_mappings` - Get mapping information for one or more data streams. [Documentation](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-get-data-stream-mappings).
* `indices.put_data_stream_mappings` - Update data stream mappings. [Documentation](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-put-data-stream-mappings).
* `inference.put_ai21` - Create an inference endpoint to perform an inference task with the `ai21` service. [Documentation](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-inference-put-ai21)
* `inference.put_contextualai` - Create an inference endpoint to perform an inference task with the `contexualai` service. [Documentation](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-inference-put-contextualai)
* `inference.put_llama` - Create an inference endpoint to perform an inference task with the `llama` service. [Documentation](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-inference-put-llama)
* `project.tags` (Experimental) -  Return tags defined for the project.
* `security.get_stats` - Gather security usage statistics from all node(s) within the cluster. [Documentation](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-get-stats)

## 9.1.3 [elasticsearch-ruby-client-9.1.3-release-notes]

### Features and enhancements [elasticsearch-ruby-client-9.1.3-features-enhancements]

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

## 9.1.2 [elasticsearch-ruby-client-9.1.2-release-notes]

### Fixes [elasticsearch-ruby-client-9.1.2-fixes]

- Fixes [2758](https://github.com/elastic/elasticsearch-ruby/issues/2758) - `msearch`, `bulk` and other NDJSON endpoints overriding headers for `content-type` and `accept`. [Pull Request](https://github.com/elastic/elasticsearch-ruby/pull/2759).

### Features and enhancements [elasticsearch-ruby-client-9.1.2-features-enhancements]

- Adds `transform.set_upgrade_mode`.
- Updates source code documentation from latest 9.1 Elasticsearch specification.

## 9.1.1 [elasticsearch-ruby-client-9.1.1-release-notes]

### Features and enhancements [elasticsearch-ruby-client-9.1.1-features-enhancements]

- Updates source code documentation to latest 9.1 specification.
- New API: `inference.put_amazonsagemaker`.

## 9.1.0 [elasticsearch-ruby-client-9.1.0-release-notes]

### Features and enhancements [elasticsearch-ruby-client-9.1.0-features-enhancements]

#### Gem

Tested versions of Ruby for 9.1.0: Ruby (MRI) 3.2, 3.3, 3.4, `head`, JRuby 9.3, JRuby 9.4 and JRuby 10.

#### Elasticsearch API

- Source code documentation and code has been updated with better formatting, updated links. It's also been updated to support common parameters and common cat parameters in APIs that support it (`error_trace`, `filter_path`, `human`, `pretty`). The API reference documentation can be generated with `rake doc`.

- `esql.async_query`, `esql.query` - adds `allow_partial_results` boolean parameter. If `true`, partial results will be returned if there are shard failures, but the query can continue to execute on other clusters and shards. If `false`, the query will fail if there are any failures. To override the default behavior, you can set the `esql.query.allow_partial_results` cluster setting to `false`. Server default: true.
- `indices.get_field_mapping` - removes `local` parameter.
- `synonyms.put_synonym`, `synonyms.put_synonym_rule` - add `refresh` boolean parameter. If `true`, the request will refresh the analyzers with the new synonym rule and wait for the new synonyms to be available before returning.

##### New APIs

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

## 9.0.5 [elasticsearch-ruby-client-9.0.5-release-notes]

### Fixes [elasticsearch-ruby-client-9.0.5-fixes]

- Fixes [2758](https://github.com/elastic/elasticsearch-ruby/issues/2758) - `msearch`, `bulk` and other NDJSON endpoints overriding headers for `content-type` and `accept`. [Pull Request](https://github.com/elastic/elasticsearch-ruby/pull/2759).

### Features and enhancements [elasticsearch-ruby-client-9.0.5-features-enhancements]

- Adds `transform.set_upgrade_mode`.

## 9.0.4 [elasticsearch-ruby-client-9.0.4-release-notes]

- Source code documentation and code has been updated to support common parameters and common cat parameters in APIs that support it (`error_trace`, `filter_path`, `human`, `pretty`). The API reference documentation can be generated with `rake doc`.
- New API: `inference.put_custom`

## 9.0.3 [elasticsearch-ruby-client-9.0.3-release-notes]

### Fixes [elasticsearch-ruby-client-9.0.3-fixes]

- Adds `ccr` alias for `cross_cluster_replication` and `slm` alias for `snapshot_lifecycle_management`.
- Tested for JRuby 10.0.0.
- General updates in source code docs.

## 9.0.2 [elasticsearch-ruby-client-9.0.2-release-notes]

### Fixes [elasticsearch-ruby-client-9.0.2-fixes]

- Udpates setting `Accept` and `Content-Type` headers as to not duplicate or overwrite user set headers [#2666](https://github.com/elastic/elasticsearch-ruby/pull/2666).

## 9.0.1 [elasticsearch-ruby-client-9.0.1-release-notes]

### Fixes [elasticsearch-ruby-client-9.0.1-fixes]

- The request headers were updated for Elasticsearch v9: `compatible-with=9` [#2660](https://github.com/elastic/elasticsearch-ruby/pull/2660).

## 9.0.0 [elasticsearch-ruby-client-900-release-notes]

### Features and enhancements [elasticsearch-ruby-client-900-features-enhancements]

Ruby 3.2 and up are tested and supported for 9.0. Older versions of Ruby have reached their end of life. We follow Ruby’s own maintenance policy and officially support all currently maintained versions per [Ruby Maintenance Branches](https://www.ruby-lang.org/en/downloads/branches/). The required Ruby version is set to `2.6` to keep compatibility with JRuby 9.3. However, we only test the code against currently supported Ruby versions.

#### Gem

The size of both `elasticsearch` and `elasticsearch-api` gems is smaller than in previous versions. Some unnecessary files that were being included in the gem have now been removed. There has also been a lot of old code cleanup for the `9.x` branch.

#### Elasticsearch Serverless

With the release of `9.0`, the [Elasticsearch Serverless](https://github.com/elastic/elasticsearch-serverless-ruby) client has been discontinued. You can use this client to build your Elasticsearch Serverless Ruby applications. The Elasticsearch Serverless API is fully supported. The CI build for Elasticsearch Ruby runs tests to ensure compatibility with Elasticsearch Serverless.

#### Elasticsearch API

* The source code is now generated from [`elasticsearch-specification`](https://github.com/elastic/elasticsearch-specification/), so the API documentation is much more detailed and extensive. The value `Elasticsearch::ES_SPECIFICATION_COMMIT` is updated with the commit hash of elasticsearch-specification in which the code is based every time it's generated.
* The API code has been updated for compatibility with Elasticsearch API v 9.0.
* `indices.get_field_mapping` - `:fields` is a required parameter.
* `knn_search` - This API has been removed. It was only ever experimental and was deprecated in v`8.4`. It isn't supported in 9.0, and only works when the header `compatible-with=8` is set. The search API should be used for all knn queries.
* The functions in `utils.rb` that had names starting with double underscore have been renamed to remove these (e.g. `__listify` to `listify`).
* **Namespaces clean up**: The API namespaces are now generated dynamically based on the elasticsearch-specification. As such, some deprecated namespace files have been removed from the codebase:
  * The `rollup` namespace was removed. The rollup feature was never GA-ed, it has been deprecated since `8.11.0` in favor of downsampling.
  * The `data_frame_deprecated`, `remote` namespace files have been removed, no APIs were available.
  * The `shutdown` namespace was removed. It is designed for indirect use by ECE/ESS and ECK. Direct use is not supported.

##### Testing

The gem `elasticsearch-api` migrated away from the Elasticsearch REST API tests and test runner in CI. We now run the [Elasticsearch Client tests](https://github.com/elastic/elasticsearch-clients-tests/) with the [Elasticsearch Tests Runner](https://github.com/elastic/es-test-runner-ruby). This gives us more control on what we're testing and makes the Buildkite way faster in pull requests and scheduled builds.

### Fixes [elasticsearch-ruby-client-900-fixes]

* Some old rake tasks that were not being used have been removed. The rest were streamlined, the `es` namespace has been streamlined to make it easier to run Elasticsearch with Docker during development. The `docker` task namespace was merged into `es`.
* Elasticsearch's REST API Spec tests can still be ran with `rake test:deprecated:rest_api` and setting the corresponding value for the environment variable `TEST_SUITE` ('platinum' or 'free').
