*To see release notes for the `7.x` branch and older releases, see [CHANGELOG on the 7.17 branch](https://github.com/elastic/elasticsearch-ruby/blob/7.17/CHANGELOG.md).*
## 8.12.0 Release notes

### Client

* Tested versions of Ruby for 8.12.0: Ruby (MRI) 3.0, 3.1, 3.2 and 3.3. JRuby 9.3 and JRuby 9.4.

### API

API Changes:

* `bulk` - Adds boolean `:list_executed_pipelines` parameter: Sets `list_executed_pipelines` for all incoming documents. Defaults to unset (false).
* `indices.put_settings` - Adds boolean `:reopen` parameter: Whether to close and reopen the index to apply non-dynamic settings. If set to `true` the indices to which the settings are being applied will be closed temporarily and then reopened in order to apply the changes. The default is `false`.
* `open_point_in_time` - Adds Hash `:body` parameter: an index_filter specified with the Query DSL.
* `security.get_api_key` - Adds boolean `:active_only` parameter: flag to limit response to only active (not invalidated or expired) API keys.

#### New APIs

New API for [Universal profiling](https://www.elastic.co/guide/en/observability/8.12/universal-profiling.html):

* `profiling.status` - Returns basic information about the status of Universal Profiling.


New experimental API:

* `simulate.ingest` - Simulates running ingest with example documents. See: https://www.elastic.co/guide/en/elasticsearch/reference/8.12/simulate-ingest-api.html

##### Connectors API

Version 8.12 introduces the experimental [Connectors API](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/connector-apis.html). Use the following APIs to manage connectors:

* `connector.post` - Creates a connector. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/create-connector-api.html)
* `connector.put` - Creates or updates a connector. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/create-connector-api.html)
* `connector.delete` - Deletes a connector. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/delete-connector-api.html)
* `connector.get` - Returns the details about a connector. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/get-connector-api.html)
* `connector.list` - Lists all connectors. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/list-connector-api.html)
* `connector.check_in` - Updates the last_seen timestamp in the connector document. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/check-in-connector-api.html)
* `connector.update_configuration` - Updates the connector configuration. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/update-connector-configuration-api.html)
* `connector.update_error` - Updates the error field in the connector document. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/update-connector-error-api.html)
* `connector.update_filtering` - Updates the filtering field in the connector document. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/update-connector-filtering-api.html)
* `connector.last_sync` - Updates the stats of last sync in the connector document. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/update-connector-last-sync-api.html)
* `connector.update_name` - Updates the name and/or description fields in the connector document. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/update-connector-name-description-api.html)
* `connector.update_pipeline` - Updates the pipeline field in the connector document. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/update-connector-pipeline-api.html)
* `connector.update_scheduling` - Updates the scheduling field in the connector document. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/update-connector-scheduling-api.html)

Use the following APIs to manage sync jobs:

* `connector_sync_job.cancel` - Cancels a connector sync job. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/cancel-connector-sync-job-api.html)
* `connector_sync_job.check_in` - Checks in a connector sync job (refreshes 'last_seen'). See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/check-in-connector-sync-job-api.html)
* `connector_sync_job.delete` - Deletes a connector sync job. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/delete-connector-sync-job-api.html)
* `connector_sync_job.error` - Sets an error for a connector sync job. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/set-connector-sync-job-error-api.html)
* `connector_sync_job.get` - Returns the details about a connector sync job. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/get-connector-sync-job-api.html)
* `connector_sync_job.list` - Lists all connector sync jobs. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/list-connector-sync-jobs-api.html)
* `connector_sync_job.post` - Creates a connector sync job. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/create-connector-sync-job-api.html)
* `connector_sync_job.update_stats` - Updates the stats fields in the connector sync job document. See [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.12/set-connector-sync-job-stats-api.html)



## 8.11.0 Release notes

### Client

* Tested versions of Ruby for 8.11.0: Ruby (MRI) 3.0, 3.1 and 3.2. JRuby 9.3 and JRuby 9.4.
* Adds native support for *Open Telemetry*. See Open Telemetry for documentation.
* Improved documentation, now you can find more examples in Ruby in the [REST API reference](https://www.elastic.co/guide/en/elasticsearch/reference/8.11/rest-apis.html).

### API

New Experimental APIs:
- `esql.query` - Executes an ESQL request.
- `inference.delete_model` - Delete model in the Inference API.
- `inference.get_model` - Get a model in the Inference API.
- `inference.inference` - Perform inference on a model.
- `inference.put_model` - Configure a model for use in the Inference API.

## 8.10.0 Release notes

### Client
* Tested versions of Ruby for 8.10.0: Ruby (MRI) 3.0, 3.1 and 3.2. JRuby 9.3 and JRuby 9.4.

### API

#### New Experimental APIs, for internal use:
- `fleet.delete_secret`
- `fleet.get_secret`
- `fleet.post_secret`

#### New stable APIs:
- `security.get_settings` - Retrieve settings for the security system indices
- `security.update_settings` - Update settings for the security system indices

#### New Experimental API:
- `query_ruleset.list` List query rulesets.

#### API Changes:
- `indices.reload_search_analyzers` - Adds parameter `resource` changed resource to reload analyzers from if applicable

Promoted from Experimental to Beta:
- `security.create_cross_cluster_api_key`
- `security.update_cross_cluster_api_key`

#### Synonyms namespace update:

All synonym related APIs have been moved to the `synonyms` namespace and some of the endpoints have been renamed, as well as their parameters:
- `synonyms.delete` => `synonyms.delete_synonym` - requires `id`, the id of the synonyms set to be deleted.
- `synonyms.get` => `synonyms.get_synonym` - requires `id`, the name of the synonyms set to be retrieved.
- `synonyms_set.get_synonyms_sets` => `synonyms.get_synonyms_sets`
- `synonyms.put` => `synonyms.put_synonym` - requires `id` of the synonyms set to be created or updated.
- `synonym_rule.put` => `synonyms.put_synonym_rule` - Parameters changed to `set_id` (the id of the synonym set to be updated with the synonym rule) and `rule_id` (the id of the synonym rule to be updated or created).
- New Experimental API `synonyms.delete_synonym_rule` - Deletes a synonym rule in a synonym set
- New Experimental API `synonyms.get_synonym_rule` - Retrieves a synonym rule from a synonym set

## 8.9.0 Release notes

### Client

* Tested versions of Ruby for 8.9.0: Ruby (MRI) 3.0, 3.1 and 3.2. JRuby 9.3 and JRuby 9.4.
* Updated product validation. The code for the product validation was refactored in a few ways:
  * Just check header, does not check the version of the server.
  * Warns only once when there's a general server error.
  * Removes the call to '/' (client.info) when doing the first request, checking on the first actual request from the client.
* Fixes User-Agent code. In the migration to 8.x, the user agent code was extracted into transport, since we're now using that library in other projects. So for the Elasticsearch Client, the user-agent would be reported as the one defined in elastic-transport. This release fixes the issue and brings back the user agent in the format that was being used in 7.x

### Helpers

This release introduces two new Helpers in the client:

* BulkHelper - This helper provides a better developer experience when using the Bulk API. At its simplest, you can send it a collection of hashes in an array, and it will bulk ingest them into {es}.
* ScrollHelper - This helper provides an easy way to get results from a Scroll.

See [Helpers](https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/Helpers.html) to read more about them.

### API

#### New APIs

* `cluster.info` - Returns different information about the cluster.

#### New Experimental APIs and namespaces:

This functionality is Experimental and may be changed or removed completely in a future release. Elastic will take a best effort approach to fix any issues, but experimental features are not subject to the support SLA of official GA features.

* New namespace: `query_ruleset`
  * `query_ruleset.delete` - Deletes a query ruleset.
  * `query_ruleset.get` - Returns the details about a query ruleset.
  * `query_ruleset.put` - Creates or updates a query ruleset.
* New API: `search_application.render_query` Renders a query for given search application search parameters.
* New API: `security.create_cross_cluster_api_key` -  Creates a cross-cluster API key for API key based remote cluster access.
* New API: `security.upate_cross_cluster_api_key` - Updates attributes of an existing cross-cluster API key.
* New namespace: `synonyms`
  * `synonyms.delete`- Deletes a synonym set
  * `synonyms.get` - Retrieves a synonym set
  * `synonyms.put` - Creates or updates a synonyms set
* New namespace: `synonym_rule`
  * `synonym_rule.put` - Creates or updates a synonym rule in a synonym set
* New namespace: `synonyms`
  * `synonyms_set.get` - Retrieves a summary of all defined synonym sets

## 8.8.0 Release notes

- Tested versions of Ruby for 8.8.0: Ruby (MRI) 3.0, 3.1 and **3.2**. JRuby 9.3 and JRuby 9.4.

### API

- Updates development dependency `minitest-reporters` to `>= 1.6` to include showing failures at the end of the test run.

#### New APIs

- `watcher.get_settings` - Retrieve settings for the watcher system index.
- `watcher.update_settings` - Update settings for the watcher system index.

#### New Experimental APIs

- `indices.delete_data_lifecycle`- Deletes the data lifecycle of the selected data streams
- `indices.explain_data_lifecycle` - Retrieves information about the index's current DLM lifecycle, such as any potential encountered error, time since creation etc.
- `indices.get_data_lifecycle` - Returns the data lifecycle of the selected data streams.
- `indices.put_data_lifecycle` - Updates the data lifecycle of the selected data streams.
- `search_application.delete` - Deletes a search application.
- `search_application.delete_behavioral_analytics` - Delete a behavioral analytics collection.
- `search_application.get` - Returns the details about a search application.
- `search_application.get_behavioral_analytics` - Returns the existing behavioral analytics collections.
- `search_application.list` - Returns the existing search applications.
- `search_application.post_behavioral_analytics_event` - Creates a behavioral analytics event for existing collection.
- `search_application.put` - Creates or updates a search application.
- `search_application.put_behavioral_analytics` - Creates a behavioral analytics collection.
- `search_application.search` - Perform a search against a search application.

#### API Changes

- `clear_scroll` now works with the argument `ignore: 404`. [Issue on GitHub](https://github.com/elastic/elasticsearch-ruby/issues/2067).
- The code generator was updated to fix a bug for `ignore: 404`. APIs that were supposed to support this wouldn't parse the parameters correctly. The support it now: `security.get_role`, `watcher.delete_watch`
- `cluster.get_component_template`, `indices.get_data_stream`, `indices.get_index_template`, `indices.simulate_index_template`, `indices.simulate_template` - Add `include_defaults` (Boolean) parameter: Return all default configurations for the component template (default: false).
- `machine_learning.put_trained_model` - Adds `wait_for_completion` (Boolean) parameter: Whether to wait for all child operations(e.g. model download) to complete, before returning or not (default: false).
- `machine_learning.start_trained_model_deployment` - Adds `deployiment_id` (String) parameter: The Id of the new deployment. Defaults to the model_id if not set.
- `search` - Adds `include_named_queries_score` (Boolean) parameter: Indicates whether hit.matched_queries should be rendered as a map that includes the name of the matched query associated with its score (true) or as an array containing the name of the matched queries (false).
- `transform.delete_transform` - Adds `delete_dest_index` (Boolean) parameter: When `true`, the destination index is deleted together with the transform. The default value is `false`, meaning that the destination index will not be deleted.

## 8.7.1 Release notes

### API Bugfix

- Updates `logstash.get_pipeline`, fixed in the specification `id` is not a required parameter, so removes raising `ArgumentError` when id is not present.

## 8.7.0 Release notes

- Tested versions of Ruby for 8.7.0: Ruby (MRI) 2.7, 3.0, 3.1 and **3.2**. JRuby 9.3 and JRuby 9.4. Ruby 2.7's end of life is coming in a few days, so this'll probably be the last release to test for Ruby 2.7.

### New APIs

- `health_report` - Returns the health of the cluster.
- `transform.schedule_now_transform` - Schedules now a transform.

### API Changes

- `transform.get_transform_stats` - Adds `timeout` (Time) parameter. Controls the time to wait for the stats.
- `transform.start_transform` - Adds `from` (String) parameter. Restricts the set of transformed entities to those changed after this time.
- `ml.delete_job`, `ml.reset_job` - Add `delete_user_annotations` (Boolean) parameter. Should annotations added by the user be deleted.
- `ml.clear_trained_model_deployment_cache`, `ml.infer_trained_model`, `ml.put_trained_model_definition_part`, `ml.put_trained_model_vocabulary`, `ml.start_trained_model_deployment`, `ml.stop_trained_model_deployment` - These APIs are no longer in Beta.

## 8.6.0 Release notes

- Tested versions of Ruby for 8.6.0: Ruby (MRI) 2.7, 3.0, 3.1 and **3.2**. JRuby 9.3 and **JRuby 9.4**.

### New APIs

- `update_trained_model_deployment` - Updates certain properties of trained model deployment (This functionality is in Beta and is subject to change).

### API Changes

- `cluster.reroute` - `:metric` parameter adds `none` as an option.
- `ml.start_trained_model_deployment` - New parameter `:priority` (String), the deployment priority


## 8.5.2 Release notes

### API Bugfix

Fixes `security.create_service_token` API, uses `POST` when token name isn't present.
Thanks [@carlosdelest](https://github.com/carlosdelest) for reporting in [#1961](https://github.com/elastic/elasticsearch-ruby/pull/1961).

## 8.5.1 Release notes

### Bugfix

Fixes bug when instantiating client with `api_key`: When passing in `api_key` and `transport_options` that don't include headers to the client, the `api_key` code would overwrite the arguments passed in for `transport_options`. This was fixed in [this Pull Request](https://github.com/elastic/elasticsearch-ruby/pull/1941/files).
Thanks [svdasein](https://github.com/svdasein) for reporting in [#1940](https://github.com/elastic/elasticsearch-ruby/issues/1940).

## 8.5.0 Release notes

- Tested versions of Ruby for 8.5.0: Ruby (MRI) 2.7, 3.0 and 3.1, JRuby 9.3.

### Client

With the latest release of `elastic-transport` - `v8.1.0` - this gem now supports Faraday v2. Elasticsearch Ruby has an open dependency on `elastic-transport` (`'elastic-transport', '~> 8'`), so when you upgrade your gems, `8.1.0` will be installed. This supports both Faraday v1 and Faraday v2. The main change on dependencies when using Faraday v2 is all adapters, except for the default `net_http` one, have been moved out of Faraday into separate gems. This means if you're not using the default adapter and you migrate to Faraday v2, you'll need to add the adapter gems to your Gemfile.

These are the gems required for the different adapters with Faraday 2, instead of the libraries on which they were based:
```
# HTTPCLient
gem 'faraday-httpclient'

# NetHTTPPersistent
gem 'faraday-net_http_persistent'

# Patron
gem 'faraday-patron'

# Typhoeus
gem 'faraday-typhoeus'
```

Things should work fine if you migrate to Faraday 2 as long as you include the adapter (unless you're using the default one `net-http`), but worst case scenario, you can always lock the version of Faraday in your project to 1.x:
`gem 'faraday', '~> 1'`

Be aware if migrating to Faraday v2 that it requires at least Ruby `2.6`, unlike Faraday v1 which requires `2.4`.

*Troubleshooting*

If you see a message like:
`:adapter is not registered on Faraday::Adapter (Faraday::Error)`
Then you probably need to include the adapter library in your gemfile and require it.

Please [submit an issue](https://github.com/elastic/elasticsearch-ruby/issues) if you encounter any problems.

### API

#### New APIs

- `machine_learning.clear_trained_model_deployment_cache` - Clear the cached results from a trained model deployment (Beta).
- `security.bulk_update_api_keys` - Updates the attributes of multiple existing API keys.

#### API Changes

- `rollup.rollup` renamed to `indices.downsample`. The method now receives the `index` to downsample (Required) and instead of `rollup_index`, use target_index as the index to store downsampled data.

- `security.get_api_key` and `security.query_api_keys` add `:with_limited_by` flag to show the limited-by role descriptors of API Keys.
- `security.get_user` adds `:with_profile_uid` flag to retrieve profile uid (if exists) associated to the user.
- `security.get_user_profile` now retrieves user profiles for given unique ID(s). `:uid` is now a list of comma-separated list of unique identifier for user profiles.
- `text_structure.find_structure` adds `:ecs_compatibility`, optional parameter to specify the compatibility mode with ECS Grok patterns - may be either 'v1' or 'disabled'.

Machine learning APIs promoted from *Experimental* to *Beta*:

- `machine_learning.clear_trained_model_deployment_cache.rb`
- `machine_learning.infer_trained_model.rb`
- `machine_learning.put_trained_model_definition_part.rb`
- `machine_learning.put_trained_model_vocabulary.rb`
- `machine_learning.start_trained_model_deployment.rb`
- `machine_learning.stop_trained_model_deployment.rb`

Security usef profile APIs promoted from *Experimental* to *Stable*:

- `security/activate_user_profile`
- `security/disable_user_profile`
- `security/enable_user_profile`
- `security/get_user_profile`
- `security/has_privileges_user_profile`
- `security/suggest_user_profile`
- `security/update_user_profile_data`


## 8.4.0 Release Notes

- Tested versions of Ruby for 8.4.0: Ruby (MRI) 2.7, 3.0 and 3.1, JRuby 9.3.

### API

#### New APIs

* `security.update_api_key` - Updates attributes of an existing API key. [Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.4/security-api-update-api-key.html).

#### API Changes

* `get` - Adds new parameter `force_synthetic_source` (Boolean) Should this request force synthetic _source? Use this to test if the mapping supports synthetic _source and to get a sense of the worst case performance. Fetches with this enabled will be slower the enabling synthetic source natively in the index.
* `machine_learning.start_trained_model_deployment` - Adds new parameter `cache_size` (String) A byte-size value for configuring the inference cache size. For example, 20mb.
* `mget` - Adds new parameter `force_synthetic_source` (Boolean) Should this request force synthetic _source? Use this to test if the mapping supports synthetic _source and to get a sense of the worst case performance. Fetches with this enabled will be slower the enabling synthetic source natively in the index.
* `search` - Adds new parameter `force_synthetic_source` (Boolean) Should this request force synthetic _source? Use this to test if the mapping supports synthetic _source and to get a sense of the worst case performance. Fetches with this enabled will be slower the enabling synthetic source natively in the index.
* `snapshot.get` - Adds new parameters:
  * `sort` (String) Allows setting a sort order for the result. Defaults to start_time (options: start_time, duration, name, repository, index_count, shard_count, failed_shard_count).
  * `size` (Integer) Maximum number of snapshots to return. Defaults to 0 which means return all that match without limit.
  * `order` (String) Sort order (options: asc, desc).
  * `from_sort_value` (String) Value of the current sort column at which to start retrieval.
  * `after` (String) Offset identifier to start pagination from as returned by the 'next' field in the response body.
  * `offset` (Integer) Numeric offset to start pagination based on the snapshots matching the request. Defaults to 0.
  * `slm_policy_filter` (String) Filter snapshots by a comma-separated list of SLM policy names that snapshots belong to. Accepts wildcards. Use the special pattern '_none' to match snapshots without an SLM policy.

## 8.3.0 Release Notes

- Tested versions of Ruby for 8.3.0: Ruby (MRI) 2.7, 3.0 and 3.1, JRuby 9.3.

### API

- Added build hash to auto generated code. The code generator obtains the git hash from the Elasticsearch specification and adds it as a comment in the code. This allows us to track the version for each generated class.
- Updated for compatibility with Elasticsearch 8.3's API.

#### API Changes

* `cluster.delete_voting_config_exclusions`, `cluster.post_voting_config_exclusions` - Add new parameter `master_timeout` (Time) Timeout for submitting request to master.
* `machine_learning.infer_trained_model_deployment` is renamed to `machine_learning.infer_trained_model`. The url `/_ml/trained_models/{model_id}/deployment/_infer` is deprecated since 8.3, use `/_ml/trained_models/{model_id}/_infer` instead.
* `machine_learning.preview_datafeed` - Adds new parameters:
  * `start` (String) The start time from where the datafeed preview should begin
  * `end` (String) The end time when the datafeed preview should stop
* `machine_learning.start_trained_model_deployment` - Adds new parameters:
  * `number_of_allocations` (Integer) The number of model allocations on each node where the model is deployed.
  * `threads_per_allocation` (Integer) The number of threads used by each model allocation during inference.
  * `queue_capacity` (Integer) Controls how many inference requests are allowed in the queue at a time.
* `search_mvt` - Adds new parameter: `with_labels` (Boolean) If true, the hits and aggs layers will contain additional point features with suggested label positions for the original features
* `snapshot.get` - Adds new parameter: `index_names` (Boolean) Whether to include the name of each index in the snapshot. Defaults to true.

#### New Experimental APIs
* `security.has_privileges_user_profile` Determines whether the users associated with the specified profile IDs have all the requested privileges

## 8.2.2 Release notes

- Updates dependency on `elastic-transport` to `~> 8.0`

## 8.2.1 Release notes

No release, no changes on the client.

## 8.2.0

- Tested versions of Ruby for 8.2.0: Ruby (MRI) 2.7, 3.0 and 3.1, JRuby 9.3.

### API

Updated for compatibility with Elasticsearch 8.2's API.

#### New parameters:

* `field_caps`
  - `filters` An optional set of filters: can include +metadata,-metadata,-nested,-multifield,-parent
  - `types` Only return results for fields that have one of the types in the list

#### New APIs:

- `cat.component_templates` - Returns information about existing component_templates templates.
- `ml.get_memory_stats` - Returns information on how ML is using memory.

#### New Experimental APIs:

- `security.activate_user_profile` - Creates or updates the user profile on behalf of another user.
- `security.disable_user_profile` -  Disables a user profile so it's not visible in user profile searches.
- `security.enable_user_profile` -  Enables a user profile so it's visible in user profile searches.
- `security.get_user_profile` -  Retrieves a user profile for the given unique ID.
- `security.suggest_user_profiles` - Get suggestions for user profiles that match specified search criteria.
- `security.update_user_profile_data` - Update application specific data for the user profile of the given unique ID.

## 8.1.2, 8.0.1

### API

- Fixes an issue with the generated API code. When updating the code generator for 8.x, the order of `arguments.clone` in the generated code was changed. This would make it so that we would modify the parameters passed in before cloning them, which is undesired. Issue: [#1727](https://github.com/elastic/elasticsearch-ruby/issues/1727).

## 8.1.1

No release, no changes on the client.

## 8.1.0

- Tested versions of Ruby for 8.1.0: Ruby (MRI) 2.6, 2.7, 3.0 and 3.1, JRuby 9.3.

### API

Updated for compatibility with Elasticsearch 8.1's API.

#### New parameters:
- `indices.forcemerge` - `wait_for_completion` Should the request wait until the force merge is completed.
- `indices.get` - `features` Return only information on specified index features (options: aliases, mappings, settings).
- `ingest.put_pipeline` `if_version` (Integer), required version for optimistic concurrency control for pipeline updates.
- `ml.delete_trained_model` - `timeout` controls the amount of time to wait for the model to be deleted. `force` (Boolean) true if the model should be forcefully deleted.
- `ml.stop_trained_model_deployment` -  `allow_no_match` whether to ignore if a wildcard expression matches no deployments. (This includes `_all` string or when no deployments have been specified). `force` true if the deployment should be forcefully stopped. Adds `body` parameter, the stop deployment parameters.
- `nodes.hot_threads` - `sort` the sort order for 'cpu' type (default: total) (options: cpu, total)

#### Updated parameters:
- `indices.get_index_template` - `name` is now a String, a pattern that returned template names must match.
- `knn_search` - `index` removes option to use empty string to perform the operation on all indices.
- `ml.close_job`, `ml.get_job_stats`, `ml.get_jobs`, `ml.get_overall_buckets` - Remove `allow_no_jobs` parameter.
- `ml.get_datafeed_stats`, `ml.get_datafeeds` - Remove `allow_no_datafeeds` parameter.
- `nodes.hot_threads` - `type` parameter adds `mem` option.
- `nodes.info` - `metric` updated to use `_all` to retrieve all metrics and `_none` to retrieve the node identity without any additional metrics. (options: settings, os, process, jvm, thread_pool, transport, http, plugins, ingest, indices, aggregations, _all, _none). `index_metric` option `shards` changes to `shard_stats`.
- `open_point_in_time` - `keep_alive` is now a required parameter.
- `search_mvt` - `grid_type` parameter adds `centroid` option in addition to `grid` and `point`.

- New experimental APIs, designed for internal use by the fleet server project: `fleet.search`, `fleet.msearch`.

#### New APIs
- OpenID Connect Authentication: `security.oidc_authenticate`, `security.oidc_logout`, `security.oidc_prepare_authentication`.
- `transform.reset_transform`.


## 8.0.0

First release for the `8.x` branch with a few major changes.

- Tested versions of Ruby for 8.0.0: Ruby (MRI) 2.6, 2.7, 3.0 and 3.1, JRuby 9.3.

### Client

#### Elastic Transport

The code for the dependency `elasticsearch-transport` has been promoted to [its own repository](https://github.com/elastic/elastic-transport-ruby/) and the project and gem have been renamed to [`elastic-transport`](https://rubygems.org/gems/elastic-transport). This gem now powers [`elasticsearch`](https://rubygems.org/gems/elasticsearch) and [`elastic-enterprise-search`](https://rubygems.org/gems/elastic-enterprise-search). The `elasticsearch-transport` gem won't be maintained after the last release in the `7.x` branch, in favour of `elastic-transport`.

This will allow us to better address maintainance in both clients and the library itself.

### API

The `elasticsearch-api` library has been generated based on the Elasticsearch 8.0.0 REST specification.

#### X-Pack Deprecation

X-Pack has been deprecated. The `elasticsearch-xpack` gem will no longer be maintained after the last release in the `7.x` branch. The "X-Pack" integration library codebase was merged into `elasticsearch-api`. All the functionality is available from `elasticsearch-api`. The `xpack` namespace was removed for accessing any APIs other than `_xpack` (`client.xpack.info`) and `_xpack/usage` (`client.xpack.usage`). But APIs which were previously available through the `xpack` namespace e.g.: `client.xpack.machine_learning` are now only available directly: `client.machine_learning`.

#### Parameter checking was removed

The code in `elasticsearch-api` will no longer validate all the parameters sent. It will only validate the required parameters such as those needed to build the path for the request. But other API parameters are going to be validated by Elasticsearch. This provides better forwards and backwards compatibility in the client.

#### Response object

In previous versions of the client, calling an API endpoint would return the JSON body of the response. With `8.0`, we are returning a new Response object `Elasticsearch::API::Response`. It still behaves like a Hash to maintain backwards compatibility, but adds the `status` and `headers` methods from the `Elastic::Transport:Transport::Response` object:

```ruby
elastic_ruby(main)> response = client.info
=> #<Elasticsearch::API::Response:0x000055752b0c50a8
 @response=
  #<Elastic::Transport::Transport::Response:0x000055752b0c50f8
   @body=
    {"name"=>"instance",
     "cluster_name"=>"elasticsearch-8-0-0-SNAPSHOT-rest-test",
     "cluster_uuid"=>"oIfRARuYRGuVYybjxQJ87w",
     "version"=>
      {"number"=>"8.0.0-SNAPSHOT",
       "build_flavor"=>"default",
       "build_type"=>"docker",
       "build_hash"=>"7e23c54eb31cc101d1a4811b9ab9c4fd33ed6a8d",
       "build_date"=>"2021-11-04T00:21:32.464485627Z",
       "build_snapshot"=>true,
       "lucene_version"=>"9.0.0",
       "minimum_wire_compatibility_version"=>"7.16.0",
       "minimum_index_compatibility_version"=>"7.0.0"},
     "tagline"=>"You Know, for Search"},
   @headers={"X-elastic-product"=>"Elasticsearch", "content-type"=>"application/json", "content-length"=>"567"},
   @status=200>>
elastic_ruby(main)> response.status
=> 200
elastic_ruby(main)> response.headers
=> {"X-elastic-product"=>"Elasticsearch", "content-type"=>"application/json", "content-length"=>"567"}
elastic_ruby(main)> response['name']
=> "instance"
elastic_ruby(main)> response['tagline']
=> "You Know, for Search"
```

Please [let us know if you find any issues](https://github.com/elastic/elasticsearch-ruby/issues).
