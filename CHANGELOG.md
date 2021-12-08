## 7.16.0

### Client
- Adds the `delay_on_retry` parameter, a value in milliseconds to wait between each failed connection, thanks [DinoPullerUqido](https://github.com/DinoPullerUqido)! [Pull Request](https://github.com/elastic/elasticsearch-ruby/pull/1521) and [backport](https://github.com/elastic/elasticsearch-ruby/pull/1523).
- Adds *CA fingerprinting*. You can configure the client to only trust certificates that are signed by a specific CA certificate (CA certificate pinning) by providing a `ca_fingerprint` option. This will verify that the fingerprint of the CA certificate that has signed the certificate of the server matches the supplied value. The verification will be run once per connection. Code example:

```ruby
ca_fingerprint = '64F2593F...'
client = Elasticsearch::Client.new(
  host: 'https://elastic:changeme@localhost:9200',
  transport_options: { ssl: { verify: false } },
  ca_fingerprint: ca_fingerprint
)
```
The verification will be run once per connection.

- Fixes compression. When `compression` is set to `true`, the client will now gzip the request body properly and use the appropiate headers. Thanks [johnnyshields](https://github.com/johnnyshields)! [Pull Request](https://github.com/elastic/elasticsearch-ruby/pull/1478) and [backport](https://github.com/elastic/elasticsearch-ruby/pull/1526).
- Warnings emitted by Elasticsearch are now logged via `log_warn` through the Loggable interface in the client, instead of using `Kernel.warn`. [Pull Request](https://github.com/elastic/elasticsearch-ruby/pull/1517).

### API

#### Updates

- Cleaned up some deprecated code.
- `count` - The API is documented as using `GET`, but it supports both GET and POST on the Elasticsearch side. So it was updated to only use `POST` when there's a body present, or else use `GET`. Elasticsearch would still accept a body with `GET`, but to be more semantically correct in the clients we use `POST` when there's a body.
- `delete_index_template` was updated to support the `ignore_404` parameter to ignore 404 errors when attempting to delete a non-existing template.
- `ingest.put_pipeline` adds new parameter `if_version`: Required version for optimistic concurrency control for pipeline updates.
- `ml.put_trained_model`: adds new parameter `defer_definition_decompression`: If set to `true` and a `compressed_definition` is provided, the request defers definition decompression and skips relevant validations.
- `nodes.hot_threads` adds new parameter `sort`: The sort order for 'cpu' type (default: total) (options: cpu, total).
- `open_point_in_time`: `keep_alive` is now a required parameter.
- `search_mvt`: adds new parameter `track_total_hits`: Indicate if the number of documents that match the query should be tracked. A number can also be specified, to accurately track the total hit count up to the number.
- `transform.preview_transform`: adds new parameter `transform_id`. Body is now optional and the API will use `GET` or `POST` depending on the presence of a body.

##### APIs promoted from experimental to stable since last version:

- `fleet.global_checkpoints`
- `get_script_context`
- `get_script_language`
- `indices.resolve_index`
- `monitoring.bulk`
- `rank_eval`
- `searchable_snapshots.mount`
- `searchable_snapshots.stats`
- `security.clear_cached_service_tokens`
- `security.create_service_token`
- `security.delete_service_token`
- `security.get_service_accounts`
- `security.get_service_credentials`
- `shutdown.delete_node`
- `shutdown.get_node`
- `shutdown.put_node`
- `terms_enum`

#### New APIs

- `fleet.mseach`
- `fleet.search`
- `indices.modify_data_stream`
- `ml.infer_trained_model_deployment`
- `ml.start_trained_model_deployment`
- `ml.stop_trained_model_deployment`
- `migration.get_feature_upgrade_status`
- `migration.post_feature_upgrade_status`
- `security.enroll_kibana`
- `security.enroll_node`
- `transform.updgrade_transforms`

## 7.15.0

### Client

We've tested and added documentation on best practices for leveraging the client in a Function-as-a-Service (FaaS) environment to the [official docs](https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/connecting.html#client-faas).

### API

- New experimental endpoints: `indices.disk_usage`. `indices.field_usage_stats`, `nodes.clear_repositories_metering_archive`, `get_repositories_metering_info`, [`search_mvt`](https://www.elastic.co/guide/en/elasticsearch/reference/master/search-vector-tile-api.html)
- The `index` parameter is now required for `open_point_in_time`.
- The `index_metric` parameter in `nodes.stats` adds the `shards` option.

### X-Pack

- New parameters for `ml.put_job`: `ignore_unavailable`, `allow_no_indices`, `ignore_throttled`, `expand_wildcards`.
- New endpoint: `security.query_api_keys`. [Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/7.15/security-api-query-api-key.html)


## 7.14.1

### Client

 - Fixes for Manticore Implementation: Addresses custom headers on initialization (https://github.com/elastic/elasticsearch-ruby/commit/3732dd4f6de75365460fa99c1cd89668b107ef1c) and fixes tracing (https://github.com/elastic/elasticsearch-ruby/commit/3c48ebd9a783988d1f71bfb9940459832ccd63e4). Related to #1426 and #1428.

## 7.14.0

### Client

Added check that client is connected to an Elasticsearch cluster. If the client isn't connected to a supported Elasticsearch cluster the `UnsupportedProductError` exception will be raised.

This release changes the way in which the transport layer and the client interact. Previously, when using `elasticsearch-transport`, `Elasticsearch::Transport::Client` had a convenient wrapper, so it could be used as `Elasticsearch::Client`. Now, we are decoupling the transport layer from the Elasticsearch client. If you're using the `elasticsearch` gem, not much will change. It will instantiate a new `Elasticsearch::Transport::Client` when you instantiate `Elasticsearch::Client` and the endpoints from `elasticsearch-api` will be available.

`Elasticsearch::Client` has an `attr_accessor` for the transport instance:

```ruby
> client = Elasticsearch::Client.new
> client.transport.class
=> Elasticsearch::Transport::Client
> client.transport.transport.class
=> Elasticsearch::Transport::Transport::HTTP::Faraday
```

The interaction with `elasticsearch-api` remains unchanged. You can use the API endpoints just like before:

```ruby
> client.info
=> {"name"=>"instance",
 "cluster_name"=>"elasticsearch",
 "cluster_uuid"=>"id",
 "version"=>
  {"number"=>"7.14.0",
  ...
},
 "tagline"=>"You Know, for Search"}
```

Or perform request directly from the client which will return an `Elasticsearch::Transport::Response` object:

```ruby
> client.perform_request('GET', '/')
# This is the same as doing client.transport.perform_request('GET', '/')
=> #<Elasticsearch::Transport::Transport::Response:0x000055c80bf94bc8
 @body=
  {"name"=>"instance",
   "cluster_name"=>"elasticsearch",
   "cluster_uuid"=>"id",
   "version"=>
    {"number"=>"7.14.0-SNAPSHOT",
    ...
    },
   "tagline"=>"You Know, for Search"},
 @headers=
  {"content-type"=>"application/json; charset=UTF-8",
   "content-length"=>"571",
   ...
   },
 @status=200>
```

If you have any problems, please report them in [this issue](https://github.com/elastic/elasticsearch-ruby/issues/1344).

### API

Code is now generated from Elastic artifacts instead of checked out code of Elasticsearch. See [the Generator README](https://github.com/elastic/elasticsearch-ruby/blob/7.14/elasticsearch-api/utils/README.md#generate) for more info.

- Endpoints `msearch`, `msearch_template` and `search_template` remove `query_and_fetch` and `dfs_query_and_fetch` options from the `search_type` parameter.
- New parameter `include_repository` in `snapshot.get`: (boolean) Whether to include the repository name in the snapshot info. Defaults to true.

### X-Pack

X-Pack is being deprecated. The first time using `xpack` on the client, a warning will be triggered. Please check [this issue](https://github.com/elastic/elasticsearch-ruby/issues/1274) for more information.


- New endpoints: `index_lifecycle_management.migrate_to_data_tiers`, `machine_learning.reset_job`, `security.saml_authenticate`, `security.saml_complete_logout`, `security.saml_invalidate`, `security.saml_logout`, `security.saml_prepare_authentication`, `security.saml_service_provider_metadata`, `sql.delete_async`, `sql.get_async`, `sql.get_async_status`, `terms_enum`.
- New experimental endpoints: `machine_learning.infer_trained_model_deployment`, `machine_learning.start_trained_model_deployment`, `machine_learning.stop_trained_model_deployment`.
- Deprecation: `indices.freeze` and `indices.unfreeze`: Frozen indices are deprecated because they provide no benefit given improvements in heap memory utilization. They will be removed in a future release.

## 7.13.3

- API Support for Elasticsearch version 7.13.3

## 7.13.2

- Mute release, yanked from RubyGems.

### DSL 0.1.10
- Adds auto_generate_synonyms_phrase_query (@andreasklinger) (3587ebe4dcecedd1f5e09adce4ddcf6cb163e9fa)
- Adds minimum_should_match option to bool filters (@MothOnMars) (c127661f368970ad9158706b6c6134462524af56)
- Adds support for calendar_interval to DateHistogram (@tmaier) (a3214c57ee876432a165f3e75f95a947a28d1484)
- Removes auto_generate_phrase_queries deprecated parameter (850eabaff268eacbce6179e76fb9d34f271bc586)
- Removes deprecated interval parameter (6b2e3bac39cf520d52adc17aee696fb7fa1de77a)
- Use pry-byebug for MRI and pry-nav for JRuby
- Improves running tests (default value for cluster set to 'http://localhost:9200')

### DSL 0.1.9
- Adds track_total_hits option (@andreasklinger)

## 7.13.1

### Client
- Fixes thread safety issue in `get_connection` - [Pull Request](https://github.com/elastic/elasticsearch-ruby/pull/1325).

## 7.13.0

### Client

- Support for Elasticsearch version 7.13.0
- Adds support for compatibility header for Elasticsearch. If the environment variable 'ELASTIC_CLIENT_APIVERSIONING' is set to `true` or `1`, the client will send the headers `Accept` and `Content-Type` with the following value: `application/vnd.elasticsearch+json;compatible-with=7`.
- Better detection of Elasticsearch and Enterprise Search clients in the meta header used by cloud.

### API

- The REST API tests now use an artifact downloaded from the Elastic servers instead of depending of cloning `elasticsearch` locally. Check the README for more information.
- New parameter `include_unloaded_segments` in `cat.nodes`, `nodes.stats`: If set to true segment stats will include stats for segments that are not currently loaded into memory
- New parameter `summary` in `ingest.get_pipeline`: Return pipelines without their definitions (default: false)
- New parameter `index_details` in `snapshot.get`: Whether to include details of each index in the snapshot, if those details are available. Defaults to false.
- New endpoint `features.reset_features`, `ingest/geo_ip_stats`
- New experimental endpoints: `shutdown.delete_node`, `shutdown.get_node`, `shutdown.put_node`.

### X-Pack

- Refactored test tasks, made it easier to run the tests by default.
- New experimental endpoints: `fleet.global_checkpoints`, `searchable_snapshots.cache_stats`.
- New beta endpoints: `security.clear_cached_service_tokens`, `security.create_service_token`, `security.delete_service_token`, `security.get_service_accounts`, `security.get_service_credentials`
- New endpoints: `machine_learning.delete_trained_model_alias`, `machine_learning.preview_data_frame_analytics`, `machine_learning.put_trained_model_alias`.
- APIs migrated from experimental or beta to stable: `machine_learning.delete_data_frame_analytics`, `machine_learning.delete_trained_model`, `machine_learning.estimate_model_memory`, `machine_learning.explain_data_frame_analytics`, `machine_learning.get_data_frame_analytics`, `machine_learning.get_data_frame_analytics_stats`, `machine_learning.get_trained_models`, `machine_learning.get_trained_models_stats`, `machine_learning.put_data_frame_analytics`, `machine_learning.put_trained_model`, `machine_learning.start_data_frame_analytics`, `machine_learning.stop_data_frame_analytics`, `machine_learning.update_data_frame_analytics`
- New parameter `body` in `machine_learning.preview_datafeed`: The datafeed config and job config with which to execute the preview.

## 7.12.0

### Client

- Support for Elasticsearch version 7.12.0
- Ruby 3 is now tested, it was added to the entire test suite.
- New official documentation pages for configuration: [Basic Configuration](https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/basic-config.html) and [Advanced Configuration](https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/advanced-config.html).
- Integration tests runner refactored to keep skipped tests in a yaml file.

### API

- New API namespace: `features` and endpoints `features.get_features` and `snapshot.get_features`.
- `cat.plugins` adds parameter `include_bootstrap`: Include bootstrap plugins in the response.
- Update in `indices.close` parameter `wait_for_active_shards`: Sets the number of active shards to wait for before the operation returns. Set to `index-setting` to wait according to the index setting `index.write.wait_for_active_shards`, or `all` to wait for all shards, or an integer. Defaults to `0`.
- `actions.search` adds parameter `min_compatible_shard_node`: The minimum compatible version that all shards involved in search should have for this request to be successful.

### X-Pack

- New API namespace: `text_structure` and endpoints `text_structure.find_structure`.
- New API namespace: `logstash` and endpoints `logstash.delete_pipeline`, `logstash.get_pipeline`, `logstash.put_pipeline`.
- New API: `eql.get_status`.
- APIs migrated from experimental to stable: `autoscaling.delete_autoscaling_policy`, `autoscaling.get_autoscaling_capacity`, `autoscaling.get_autoscaling_policy`, `autoscaling.put_autoscaling_policy`.
- `searchable_snapshots.mount` adds parameter `storage`: Selects the kind of local storage used to accelerate searches. Experimental, and defaults to `full_copy`.
- `searchable_snapshots.stats` adds parameter `level`: Return stats aggregated at cluster, index or shard level (options: cluster, indices, shards).

## 7.11.2

### Client

* Bug fix in meta header, fixes fail when http adapter library hasn't been loaded yet: [Issue](https://github.com/elastic/elasticsearch-ruby/issues/1224).


## 7.11.1

### Client

* Bug fix in meta header, adds support for unknown Faraday adapters. [Pull Request](https://github.com/elastic/elasticsearch-ruby/pull/1204).

## 7.11.0

### Client

- Fixes a bug with headers in our default Faraday class. [Commit](https://github.com/elastic/elasticsearch-ruby/commit/9c4afc452467cc6344359b54b98bbe5af1469219).
- Adds the `X-Elastic-Client-Meta` HTTP header which is used by Elastic Cloud and can be disabled with the `enable_meta_header` parameter set to `false`.

### API

#### API Changes

- `cat.tasks` - Parameter `node_id` changes name to `nodes`, a comma-separated list of node IDS or names. Parameter `parent_task` changes name to `parent_task_id`.
- APIs that are no longer experimental: `cluster.delete_component_template`, `cluster.exists_component_template`, `cluster.get_component_template`, `cluster.put_component_template`, `indices.delete_index_template`, `indices.exists_index_template`, `indices.get_index_template`, `indices.put_index_template`, `indices.simulate_index_template`, `indices.simulate_template`.
- Deprecation notice: The _upgrade API is no longer useful and will be removed. Instead, see `_reindex API`. Deprecated since version 8.0.0. Endpoints: `indices.get_upgrade`, `indices.upgrade`

#### X-Pack

- New endpoints:`async_search.status`, `autoscaling.get_autoscaling_capacity` (experimental), `indices.migrate_to_data_stream`, `indices.promote_data_stream`, `machine_learning.upgrade_job_snapshot`, `rollup.rollup`, `watcher.query_watches`.
- APIs that are no longer experimental: `eql.delete`, `eql.get`, `eql.search`,
- APIs promoted from experimental to beta: `machine_learning.delete_data_frame_analytics`, `ml.delete_trained_model`, `machine_learning.evaluate_data_frame`, `machine_learning.explain_data_frame_analytics`, `machine_learning.get_data_frame_analytics`, `machine_learning.get_datafeed_stats`, `machine_learning.get_trained_models`, `machine_learning.get_trained_models_stats`, `machine_learning.put_data_frame_analytics`, `machine_learning.put_trained_model`, `machine_learning.start_data_frame_analytics`, `machine_learning.stop_data_frame_analytics`, `machine_learning.update_data_frame_analytics`
- `indices.delete_data_stream`, `indices.get_data_stream` add parameter `expand_wildcards`, wether wildcard expressions should get expanded to open or closed indices (default: open). Options: open, closed, hidden, none, all.
- `machine_learning.get_data_frame_analytics`, `machine_learning.get_datafeeds`, `machine_learning.get_jobs`, `machine_learning.get_trained_models`, `transform.get_transform` add parameter `exclude_generated` - omits fields that are illegal to set on PUT.
- `data_frame_transform_deprecated.get_transform` (_data_frame/transforms/ is deprecated, use _transform/ in the future) adds parameter `exclude_generated` - omits generated files.

## 7.10.1

- Use 443 for default cloud port, 9200 as the default port for http

## EXT:0.0.33

New release of [`elasticsearch-extensions`](elasticsearch-extensions):

- Fixes a bug where clusters failed to start with `"unknown setting [xpack.security.enabled]"` when running `elasticsearch-oss`. More details on the [issue](https://github.com/elastic/elasticsearch-ruby/issues/1130) ([commit](https://github.com/elastic/elasticsearch-ruby/commit/23a1302db43ad45f6ce5d1ac4fcfcc1d824609f3)).

## EXT:0.0.32

New release of [`elasticsearch-extensions`](elasticsearch-extensions):

- Fixes parsing Elasticsearch version when a major, minor or patch have more than 1 digit (e.g. 7.10.0) ([commit](https://github.com/elastic/elasticsearch-ruby/commit/1d7a4b58e2605e946206f8e1720b1ddde710aef0)).
- Changes the key of the parameter of Reindex from `target` to `dest` by @tetsuya-ogawa ([commit](https://github.com/elastic/elasticsearch-ruby/commit/25a983f7d848fc8bf0345ff3fe6011ef90c8c4c3#diff-6ec4953cb34b5a3a20740404a942fce4e4de749f2162d9c88cc72e2b3a483474)).
- Fixes test cluster clear_cluster option by @Lajcisvk ([commit](https://github.com/elastic/elasticsearch-ruby/commit/f55b56ed2a54299c5f5ed52a6513d186acd411db#diff-6ec4953cb34b5a3a20740404a942fce4e4de749f2162d9c88cc72e2b3a483474)).
- Sanitizes filename in the backup extension ([commit](https://github.com/elastic/elasticsearch-ruby/commit/6c055690782baf87f3b09e713b53b3d508af5197#diff-6ec4953cb34b5a3a20740404a942fce4e4de749f2162d9c88cc72e2b3a483474)).
- Adds 8.0.0 to cluster tasks ([commit](https://github.com/elastic/elasticsearch-ruby/commit/c3189328291b1a83f2c857e504ad9b75e20a7f93#diff-6ec4953cb34b5a3a20740404a942fce4e4de749f2162d9c88cc72e2b3a483474)).

## 7.10.0

### Client

- Support for Elasticsearch version `7.10.0`.
- Fixes a bug when building the complete endpoint URL could end with duplicate slashes `//`.
- Fixes a bug when building the complete endpoint URL with cloud id could end with duplicate ports [#1081](https://github.com/elastic/elasticsearch-ruby/issues/1081).


### API

- Fix in RubyDoc comments, some parameters were being duplicated.
- Deprecation notice: Synced flush (`indices.flush_synced`) is deprecated and will be removed in 8.0. Use flush instead.

#### New API Endpoints

- `snapshot.clone`

#### API Changes

- `bulk`, `index`, `update`: new parameter `require_alias` (boolean):  When true, requires destination to be an alias (default: false) for `index` and `update`. For `bulk` it sets `require_alias` for all incoming documents. Defaults to unset (false).

### X-Pack

Deprecation notice: `searchable_snapshots.repository_stats` is deprecated and is replaced by the Repositories Metering API.

#### New API Endpoints

- `close_point_in_time`
- `open_point_in_time`
- `security.clear_api_key_cache`
- `security.grant_api_key`

#### API Changes

- `cat.ml_datafeeds`, `cat.ml_jobs`, `machine_learning.close_job`, `machine_learning.get_datafeed_stats`, `machine_learning.get_datafeeds`, `machine_learning.get_job_stats`, `machine_learning.get_jobs`, `machine_learning.get_overall_buckets`, `machine_learning.stop_datafeed`: new parameter `allow_no_match` (boolean): Whether to ignore if a wildcard expression matches no datafeeds. (This includes `_all` string or when no datafeeds have been specified)
-`machine_learning.get_data_frame_analytics`: new parameter `verbose` (boolean), whether the stats response should be verbose
- `machine_learning.get_trained_models`: new parameter `include` (string), a comma-separate list of fields to optionally include. Valid options are 'definition' and 'total_feature_importance'. Default is none.
- `machine_learning.stop_datafeed`: endpoint now accepts a `body`: the URL params optionally sent in the body
- `security.get_role`, `security/get_role_mapping`: The name parameter is now a comma-separated list of role-mapping names
- `machine_learning.delete_trained_model`, `machine_learning.get_trained_models`, `machine_learning.get_trained_models_stats`, `machine_learning.put_trained_model`: Internal change, url changed from `_ml/inference` to `_ml/trained_models`

## 7.9.0

### Client

- Support for Elasticsearch version `7.9.0`.
- Transport/Connection: Considers attributes values for equality - [Commit](https://github.com/elastic/elasticsearch-ruby/commit/06ffd03bf51f5f33a0d87e9914e66b39357d40af).
- When an API endpoint accepts both `GET` and `POST`, the client will always use `POST` when a request body is present.

### API

- Documentation for API endpoints will point out when an API is experimental, beta or unstable.

#### New API Endpoints

- New namespace: `dangling_indices`
- `dangling_indices.delete_dangling_index`
- `dangling_indices.import_dangling_index`
- `dangling_indices.list_dangling_indices`
- `indices.add_block`

Experimental endpoints:
- `indices.resolve_index`
- `simulate_template`

#### API Changes

- `field_caps`: adds body parameter allowing to filter indices if `index_filter` is provided.
- `eql.search`: new parameters `wait_for_completion`, `keep_on_completion` and `keep_alive`.
- `info`: New parameter `accept_enterprise`: If an enterprise license is installed, return the type and mode as 'enterprise' (default: false).
- `indices.put_mapping`: new parameter `write_index_only`.


### X-Pack

#### New API Endpoints

The Ruby client now supports all the X-Pack API endpoints.

- New namespace `autoscaling`: `autoscaling.delete_autoscaling_policy`, `autoscaling.get_autoscaling_decision`, `autoscaling.get_autoscaling_policy`, `autoscaling.put_autoscaling_policy`
- New namespace `enrich`: `enrich.delete_policy`, `enrich.execute_policy`, `enrich.get_policy`, `enrich.put_policy`, `enrich.stats`
- New namespace `eql`: `eql.delete`, `eql.get`, `eql.search`
- New namespace `cross_cluster_replication`: `cross_cluster_replication.delete_auto_follow_pattern`, `cross_cluster_replication.follow`, `cross_cluster_replication.follow_info`, `cross_cluster_replication.follow_stats`, `cross_cluster_replication.forget_follower`, `cross_cluster_replication.get_auto_follow_pattern`, `cross_cluster_replication.pause_auto_follow_pattern`, `cross_cluster_replication.pause_follow`, `cross_cluster_replication.put_auto_follow_pattern`, `cross_cluster_replication.resume_auto_follow_pattern`, `cross_cluster_replication.resume_follow`, `cross_cluster_replication.stats`, `cross_cluster_replication.unfollow`
- New namespace `snapshot_lifecycle_management`: `snapshot_lifecycle_management.delete_lifecycle`, `snapshot_lifecycle_management.execute_lifecycle`, `snapshot_lifecycle_management.execute_retention`, `snapshot_lifecycle_management.get_lifecycle`, `snapshot_lifecycle_management.get_stats`, `snapshot_lifecycle_management.get_status`, `snapshot_lifecycle_management.put_lifecycle`, `snapshot_lifecycle_management.start`, `snapshot_lifecycle_management.stop`
- `indices.create_data_stream`
- `indices.data_streams_stats`
- `indices.delete_data_stream`
- `indices.get_data_stream`
- `security.clear_cached_privileges`
- `machine_learning.update_data_frame_analytics`

#### API Changes

- `machine_learning.delete_expired_data`: new parameters `job_id`, `requests_per_second` and `timeout`

## 7.8.1

### Client

- Support for Elasticsearch version `7.8.1`.
- Bug fix: Fixed a bug on the API endpoints documentation for RubyDocs: there was an unnecessary empty new line in the documentation for parameters that have options. So the parameters before that empty newline were not being documented in RubyDocs.

### X-Pack

#### API Changes

- Update to `info` endpoint. New parameter `accept_enterprise` (boolean): If an enterprise license is installed, return the type and mode as 'enterprise' (default: false).

## 7.8.0

### Client

- Support for Elasticsearch version `7.8`.
- Surface deprecation headers from Elasticsearch. When there's a `warning` response header in Elasticsearch's response, the client will emit a warning with `warn`.
- Typhoeus is supported again, version 1.4+ and has been added back to the docs.
- Adds documentation and example for integrating with Elastic APM.

### API

#### New API Endpoints

- `abort_benchmark`
- `benchmark`
- `cluster.delete_voting_config_exclusions`
- `cluster.post_voting_config_exclusions`
- `delete_by_rethrottle`
- `nodes.shutdown`
- `remote.info`

Experimental endpoints:

- `cluster.delete_component_template`
- `cluster.exists_component_template`
- `cluster.get_component_template`
- `cluster.put_component_template`

- `indices.delete_index_template`
- `indices.exists_index_template`
- `indices.get_index_template`
- `indices.put_index_template`
- `indices.simulate_index_template`

#### API Changes

- `cat/thread_pool`: `size` is deprecated.
- `indices.get_data_streams`: `name` is now a string instead of list, the name or wildcard expression of the requested data streams.
- `indices.put_index_template`: new parameter: `cause` (string), user defined reason for creating/updating the index template.
- `indices.simulate_index_template`: Two new parameters: `create`, whether the index template we optionally defined in the body should only be dry-run added if new or can also replace an existing one. `cause` User defined reason for dry-run creating the new template for simulation purposes.
- `snapshot.delete_repository`: New parameter `repository`, name of the snapshot repository, wildcard (`*`) patterns are now supported.
- `task.cancel`: new parameter `wait_for_completion` (boolean) Should the request block until the cancellation of the task and its descendant tasks is completed. Defaults to false.

### X-Pack

#### New API Endpoints

New namespace: `indices`
- `indices.freeze`
- `indices.reload_search_analyzers`
- `indices.unfreeze`

New namespace: `searchable_snapshots`
- `clear_cache`
- `mount`
- `repository_stats`
- `stats`

#### API Changes

- `machine_learning.delete_expired_data` new param `body`: deleting expired data parameters.
- `machine_learning.delete_data_frame_analytics` new param `timeout`: controls the time to wait until a job is deleted. Defaults to 1 minute.

## 7.7.0

This version drops support for Ruby 2.4 since it's reached it's end of life.

### Client

- Support for Elasticsearch version `7.7`

#### Custom Headers

You can set custom HTTP headers on the client's initializer or pass them as a parameter to any API endpoint. [More info and code examples](https://github.com/elastic/elasticsearch-ruby/tree/7.x/elasticsearch-transport#custom-http-headers).

### API

#### API Changes

- Clean: Removes up some deprecated endpoints: `abort_benchmark`, `benchmark`, `delete_by_rethrottle`, `nodes.shutdown`, `remote.info`.
- `expand_wildcards` Whether to expand wildcard expressions to concrete indices that are open, closed or both. Options: open, closed, hidden, none, all. `hidden` option is new. It was also added to the following endpoints: `cat.aliases`, `cat.indices`.
- `delete_by_query`: Parameter `slices` can now be set to `auto`.
- `reindex`: Parameter `slices` can now be set to `auto`.
- `update_by_query`: Parameter `slices` can now be set to `auto`.
- `snapshot.cleanup_repository`: Parameter `body` is removed.

#### New API Endpoints

- `cluster.delete_component_template`
- `cluster.get_component_template`
- `cluster.put_component_template`
- `indices.create_data_stream` (experimental)
- `indices.delete_data_stream` (experimental)
- `indices.get_data_stream` (experimental)

### X-Pack

#### API Changes

- `machine_learing.get_trained_models`: New parameter `tags`
- `machine_learning.put_datafeed`, `machine_learning.update_datafeed`: Added parameters `ignore_unavailable`, `allow_no_indices`, `ignore_throttled`, `expand_wildcards`
- `reload_secure_settings`: New parameter `body`, an object containing the password for the keystore.

#### New API Endpoints

- `async_search.delete`
- `async_search.get`
- `async_search.submit`
- `cat.ml_data_frame_analytics`
- `cat.ml_datafeeds`
- `cat.ml_jobs`
- `cat.ml_trained_models`
- `cat.transform`
- `cat.transforms`
- `machine_learning.estimate_model_memory`
- `transform.delete_transform`
- `transform.get_transform`
- `transform.get_transform_stats`
- `transform.preview_transform`
- `transform.put_transform`
- `transform.start_transform`
- `transform.stop_transform`
- `transform.update_transform`

## 7.6.0

### Client

- Support for Elasticsearch version `7.6`.
- Last release supporting Ruby 2.4. Ruby 2.4 has reached it's end of life and no more security updates will be provided, users are suggested to update to a newer version of Ruby.

#### API Key Support
The client now supports API Key Authentication, check "Authentication" on the [transport README](https://github.com/elastic/elasticsearch-ruby/tree/7.x/elasticsearch-transport#authentication) for information on how to use it.

#### X-Opaque-Id Support

The client now supports identifying running tasks with X-Opaque-Id. Check [transport README](https://github.com/elastic/elasticsearch-ruby/tree/7.x/elasticsearch-transport#identifying-running-tasks-with-x-opaque-id) for information on how to use X-Opaque-Id.

#### Faraday migrated to 1.0

We're now using version 1.0 of Faraday:
- The client initializer was modified but this should not disrupt final users at all, check [this commit](https://github.com/elastic/elasticsearch-ruby/commit/0fdc6533f4621a549a4cb99e778bbd827461a2d0) for more information.
- Migrated error checking to remove the deprecated `Faraday::Error` namespace.
- **This change is not compatible with [Typhoeus](https://github.com/typhoeus/typhoeus)**. The latest release is 1.3.1, but it's [still using the deprecated `Faraday::Error` namespace](https://github.com/typhoeus/typhoeus/blob/v1.3.1/lib/typhoeus/adapters/faraday.rb#L100). This has been fixed on master, but the last release was November 6, 2018. Version 1.4.0 should be ok once it's released.
- Note: Faraday 1.0 drops official support for JRuby. It installs fine on the tests we run with JRuby in this repo, but it's something we should pay attention to.

Reference: [Upgrading - Faraday 1.0](https://github.com/lostisland/faraday/blob/master/UPGRADING.md)

[Pull Request](https://github.com/elastic/elasticsearch-ruby/pull/808)

### API

#### API Changes:
- `cat.indices`: argument `bytes` options were: `b,k,m,g` and are now `b,k,kb,m,mb,g,gb,t,tb,p,pb`.
- `delete_by_query`: New parameter `analyzer` - The analyzer to use for the query string.
- `indices.put_template`: Removed parameters: `timeout`, `flat_settings`.
- `msearch_template`: New Parameter `ccs_minimize_roundtrips` - Indicates whether network round-trips should be minimized as part of cross-cluster search requests execution.
- `rank_eval`: New parameter `search_type` - Search operation type (options: `query_then_fetch,dfs_query_then_fetch`).
- `search_template`: New parameter `ccs_minimize_roundtrips` - Indicates whether network round-trips should be minimized as part of cross-cluster search requests execution.

#### New API endpoints:
- `get_script_context`
- `get_script_languages`

#### Warnings:
Synced flush is deprecated and will be removed in 8.0.

### X-Pack

#### New API endpoints:
- `ml/delete_trained_model`
- `ml/explain_data_frame_analytics`
- `ml/get_trained_models`
- `ml/get_trained_models_stats`
- `ml/put_trained_model`

#### API changes:
- `license/get`: Added parameter `accept_enterprise`.
- `ml/delete_data_frame_analytics` Added parameter `force`.
-  `monitoring/bulk` - Removed parameter `system_version`.

## 7.5.0

- Support for Elasticsearch 7.5.
- Update API spec generator: The code for Elasticsearch OSS and X-Pack APIs is being generated from the rest api spec.
- Specs have been updated to address new/deprecated parameters.
- Ruby versions tested: 2.3.8, 2.4.9, 2.5.7, 2.6.5 and 2.7.0 (new).

### API

Endpoints that changed:
- `_bulk`: body is now required as an argument.
- `cat`: `local` and `master_timeout` parameters are gone.
  - `health`: New parameter `health`.
  - `indices`: Adds `time` and `include_unload_segments` parameters.
  - `nodes`: Adds `bytes`, `time` parameters.
  - `pending_tasks`: Adds `time` parameter.
  - `recovery`: Adds `active_only`, `detailed`, `index`, `time` parameters.
  - `segments`: Removes `index` parameter and it's now a url part.
  - `shards`: Adds `time` parameter.
  - `snapshots`: Adds `time` parameter.
  - `tasks`: Adds `time` parameter.
  - `templates`: The `name` parameter is now passed in as a part but not a parameter.
  - `thread_pool`: The `thread_pool_patterns` parameter is now passed in as a part but not as a parameter.
- `cluster`
  - `put_settings`: body is required.
  - `state`: `index_templates` is gone.
  - `node_id` is now a url part.
- `delete` - `parent` parameter is gone.
- `delete_by_query`: `analyzer`  parameters are gone, `max_docs` is a new parameter, `body` is now a required parameter.
- `delete_by_query_rethrottle` new endpoint.
- `delete_by_rethrottle` - uses `delete_by_query_rethrottle` and hasn't changed.
- `exists`, `exists_source`, `explain`: `parent` parameter is gone.
- `field_caps`: `fields` param is no longer required.
- `get`: `parent` parameter is gone
- `get_source`: `parent` parameter is gone
- `index`: `body` parameter is required, `wait_for_shard` is a new parameter, `consistency`, `include_type_name`, `parent`, `percolate`, `replication`, `timestamp`, `ttl` parameters are gone
- `indices`
  - `get`: `feature` paramatere was deprecated and is gone.
  - `delete_aliases`, `put_alias`: URL changed internally to 'aliases' instead of 'alias' but shouldn't affect the client's API.
- `render_search_template`: `id` is now a part not a parameter
- `search`: `fielddata_fields`, `include_type_name`, `fields`, `ignore_indices`, `lowercase_expanded_terms`, `query_cache`, `source` parameters are gone, `ccs_minimize_roundtrips`, `track_scores` are new parameters.
- `tasks` - `list`: task_id is not supported anymore, it's in get now.
- `termvectors`: `parent` parameter is gone.
- `update`: `version` parameter is not supported anymore.

### X-PACK

Some urls changed internally to remove `_xpack`, but it shouldn't affect the client's API.

- `explore`: `index` is now required.
- `info`: `human` parameter is gone.
- `migration`: some endpoints are gone: `get_assistance`, `get_assistance_test` and `upgrade_test`.
- `watcher`: `restart` endpoint is gone.


## 7.4.0

### Client

* Accept options passed to #perform_request to avoid infinite retry loop
* Fix minor typo

### API

* Update documentation of put_script method

### EXT:7.4.0



### XPACK

* Add ParamsRegistry in each direcotry and for Xpack top-level API
* Add ParamsRegistry for Xpack data_frame API
* Add ParamsRegistry for Xpack graph API
* Add ParamsRegistry for Xpack license API
* Add ParamsRegistry for Xpack MachineLearning API
* Fix path for loading params_registry files
* Add ParamsRegistry for Xpack Migration API
* Add ParamsRegistry for Xpack Monitoring API
* Add ParamsRegistry for Xpack Rollup API
* Add ParamsRegistry for Xpack security API
* Add ParamsRegistry for Xpack sql API
* Add ParamsRegistry for Xpack watcher API
* Update missed file with ParamsRegistry
* Update versions in params registry files
* Add update_data_frame_transform
* Support Index Lifecycle Management(ILM) API

## 7.3.0

### Client

* Add note to readme about the default port value
* Add note about exception to default port rule when connecting using Elastic Cloud ID
* Cluster name is variable in cloud id

### XPACK

* Support allow_no_match parameter in stop_data_frame_transform
* Add allow_no_match to get_data_frame_transform API
* Add missing headers
* Support get_builtin_privileges API
* Update tests for changed xpack paths
* test:integration task in xpack gem shouldn't do anything in favor of test:rest_api

## 7.2.0

### Client

* Support User-Agent header client team specification
* Improve code handling headers
* Handle headers when using JRuby and Manticore
* Rename method for clarity
* Test selecting connections using multiple threads
* Synchronize access to the connections collection and mutation of @current instance variable
* Fix specs for selecting a connection
* Further fixes to specs for testing selecting connections in parallel
* Support providing a cloud id
* Allow a port to be set with a Cloud id and use default if no port is provided
* Remove unnecessary check for cloud_id when setting default port
* Add documentation for creating client with cloud_id
* Allow compression with Faraday and supported http adapters
* Put development gem dependencies in gemspec
* No reason to use ! for decompress method name
* Check for the existence of headers before checking headers
* Apply compression headers manually based on general :compression option
* Use GZIP constant
* Group tests into their transport adapters
* Support compression when using Curb adapter
* Support compression when using Manticore adapter with JRuby
* Fix Curb unit test, expecting headers to be merged and not set
* Update test descriptions for compression settings
* Add documentation of 'compression' option on client
* Improve client documentation for compression option
* Centralize header handling into one method
* Only add Accept-Encoding header if compression option is true

### API

* Use rewritten test harness from XPACK for rest API tests
* Include skipped tests and further updates
* Delete all repositories and snapshots in a method
* Further updates to the rest API test runner
* Add erroneously removed constants and gems
* Updates to rest api yaml rspec tasks
* The get_source endpoint should raise an error if the resource is not found
* Rename method to clear data in tests and consolidate tasks into one method
* Update api for 7.2

### EXT:7.2.0



### XPACK

* Add data_frame API
* Update data frame files

## 7.1.0

### Client

* Update elasticsearch-transport README
* Use default port when host and protocol are specified but no port
* Verify that we have a response object before checking its status
* Make code more succinct for supporting host with path and no port
* Support options specified with String keys
* Update elasticsearch-transport/lib/elasticsearch/transport/client.rb
* Add tests showing IPv6 host specified when creating client

### API

* Update links in elasticsearch-api README

### DSL 0.1.8

* Swap links elasticsearch.org->elastic.co (@harry-wood)
* Add a composite aggregation (@watsonjon)
* Don't specify a type when creating mappings in tests
* Update links in elasticsearch-dsl README
* Allow Bool query and Bool filter methods to take objects as arguments
* Edit tests on bool query / filter to match context

## 7.0.0.pre

* Added `elastic_ruby_console` executable
### Client

* Fixed failing integration test
* Updated the Manticore development dependency
* Fixed a failing Manticore unit test
* Removed "turn" and switched the tests to Minitest
* Fixed integration tests for Patron
* Allow passing request headers in `perform_request`
* Added integration test for passing request headers in `perform_request`
* Added, that request headers are printed in trace output, if set
* Fix typos in elasticsearch-transport/README.md
* Assert that connection count is at least previous count when reloaded
* Adjust test for change in default number of shards on ES 7
* Abstract logging functionality into a Loggable Module (#556)
* Convert client integration tests to rspec
* Add flexible configuration in spec helper
* Use helper methods in spec_helper
* Remove minitest client integration tests in favor of rspec test
* Convert tests to rspec and refactor client
* minor changes to the client specs
* Use pry-nav in development for JRuby
* Keep arguments variable name for now
* Skip round-robin test for now
* Mark test as pending until there is a better way to detect rotating nodes
* Remove client unit test in favor of rspec test
* Comment-out round-robin test as it occasionally passes and pending is ineffective
* Document the default host and port constant
* Add documentation to spec_helper methods
* Redacted password if host info is printed in error message
* Adds tests for not including password in logged error message
* The redacted string change will be in 6.1.1
* Add more tests for different ways to specify client host argument
* Do not duplicate connections in connection pool after rebuild (#591)
* Ensure that the spec rake task is run as part of integration tests
* Use constant to define Elasticsearch hosts and avoid yellow status when number of nodes is 1
* Update handling of publish_address in _nodes/http response
* Add another test for hostname/ipv6:port format

### API

* Added the `wait_for_active_shards` parameter to the "Indices Open" API
* Added the "Indices Split" API
* Added the `wait_for_no_initializing_shards` argument to the "Cluster Health" API
* Added the "Cluster Remote Info" API
* Remove the dependency on "turn"
* Clear cluster transient settings in test setups
* Use `YAML.load_documents` in the REST tests runner
* Removed pinning dependency for Minitest
* Replaced the testing framework from Test::Unit to Minites and improved test output
* Added, that trace logs are printed when the `TRACE` environment variable is set
* Removed the "turn" dependency from generated test_helper.rb
* Update the "Delete By Query" API to support :slices
* Speed up `Elasticsearch::API::Utils.__listify`
* Speed up `Elasticsearch::API::Utils.__pathify`
* Use "String#strip" and "String.empty?" in `Utils.__pathify`
* Updated the inline documentation for using scripts in the "Update" API
* Updated the "Scroll" API inline example with passing the scroll ID in the body
* Marked the `percolate` method as deprecated and added an example for current percolator
* Fixed, that `Utils.__report_unsupported_parameters` and `Utils.__report_unsupported_method` use `Kernel.warn` so they can be suppressed
* Fixed the "greedy" regex in the `Utils.__rescue_from_not_found` method
* Fixed the incorrect `create` method
* Allow passing headers in `perform_request`
* Set application/x-ndjson content type on Bulk and Msearch requests
* Update the Reindex API to support :slices
* Fixed and improved the YAML tests runner
* Added the `include_type_name` parameter to APIs
* Fixed the helper for unit tests
* Removed the requirement for passing the `type` parameter to APIs
* Removed dead code from the YAML tests runner
* Fixed the `api:code:generate` Thor task
* Add copy_settings as valid param to split API
* Port api/actions tests to rspec (#543)
* Update tests to not require type
* Account for escape_utils not being available for JRuby
* Add nodes/reload_secure_settings endpoint support (#546)
* Add new params for search and msearch API
* Retrieve stashed variable if referenced in test
* Convert cat API tests to rspec
* Convert cluster API tests to rspec
* Convert indices tests to rspec
* Fix documentation of #indices.analyze
* Avoid instantiating an array of valid params for each request, each time it is called (#550)
* Add headers to custom client documentation (#527)
* Fix typos in README
* Minor update to scroll documentation example
* Convert snapshot, ingest, tasks, nodes api tests to rspec
* Update source_includes and source_excludes params names for mget
* Update source_includes and source_excludes params names for get, search, bulk, explain
* Update source_includes and source_excludes params names for get_source
* Mark _search endpoint as deprecated
* Link to 6.0 documentation explicitly for _suggest deprecation
* Update documentation for msearch
* Update documentation for scroll_id to be in body of scroll endpoint
* Remove reference to deprecated format option for _analyze endpoint
* Correct endpoints used for get and put search template
* Fix minor typo
* Note that a non-empty body argument is required for the bulk api
* Add note about empty body in yard documentation
* Support if_primary_term param on index API
* Delete test2 template in between tests in case a test is not cleanup up properly
* Support ignore_throttled option on search API
* Updates for types removal changes
* Add missing update param
* Add missing params to methods
* Support if_primary_term param for delete
* Delete an index and index template not cleaned up after in rest api tests
* Update supported params for cat API endpoints
* Update supported params for cluster API endpoints
* Update supported params for indices API endpoints
* Update supported params for ingest API endpoints
* Update supported params for nodes API endpoints
* Update supported params for snapshot API endpoints
* Update missed node API endpoints
* Update missed tasks API endpoints
* Update top-level api endpoints
* Adjust specs and code after test failures
* Fix accidental overwrite of index code
* Add missing param in cat/thread_pool
* The type argument is not required in the index method
* Delete 'nomatch' template to account for lack of test cleanup
* Ensure that the :index param is supported for cat.segments
* Ensure that the :name param is passed to the templates API

### DSL

* Add inner_hits option support for has_parent query
* Add inner_hits option support for has_child query
* Add inner_hits option support for has_parent filter
* Add inner_hits option support for has_child filter
* adds query support for nested queries in filter context (#531)
* Convert aggregations/pipeline tests to rspec (#564)
* Convert aggregations tests to rspec (#566)
* Convert filters tests to rspec (#567)
* Fix bug in applying no_match_filter to indices filter
* Update test for current elasticsearch version
* Fix integration tests for join field syntax
* Update agg scripted metric test for deprecation in ES issue #29328
* Fix script in update for #29328
* minor: fix spacing
* Convert queries tests to rspec (#569)
* Add inner_hits test after cherry-picking rspec conversion
* Remove tests already converted to rspec
* spec directory structure should mirror code directory structure
* Support query_string type option
* Ensure that filters are registered when called on bool queries (#609)
* Don't specify a type when creating mappings in tests

### XPACK

* Embedded the source code for the `elasticsearch-xpack` Rubygem
* Fixed the `setup` for YAML integration tests
* Added missing X-Pack APIs
* Improved the YAML integration test runner
* Updated the Rakefile for running integration tests
* Added, that password for Elasticsearch is generated
* Fixed the Watcher example
* Updated the README
* Added gitignore for the `elasticsearch-xpack` Rubygem
* Add ruby-prof as a development dependency
* Handle multiple roles passed to get_role_mapping
* Minor updates to xpack api methods (#586)
* Support freeze and unfreeze APIs
* Rewrite xpack rest api yaml test handler (#585)
* Updates to take into account SSL settings
* Fix mistake in testing version range so test can be skipped
* Support set_upgrade_mode machine learning API
* Support typed_keys and rest_total_hits_as_int params for rollup_search
* Improve string output for xpack rest api tests
* Fix logic in version checking
* Support if_seq_no and if_primary_term in put_watch
* Don't test execute_watch/60_http_input because of possible Docker issue
* Support api key methods
* Fix minor typo in test description
* Fix issue with replacing argument value with an Integer value
* Support transform_and_set in yaml tests
* Skip two more tests
* Run security tests against elasticsearch 7.0.0-rc2
* Account for error when forecast_id is not provided and legacy path is used
* Blacklist specific tests, not the whole file
* Fix version check for skipping test

_Note: Up-to-date changelogs for each version can be found in their respective branches
(e.g. [1.x/CHANGELOG.md](https://github.com/elastic/elasticsearch-ruby/blob/1.x/CHANGELOG.md))_

## 6.0.0

Elasticsearch 6.0 compatibility.

### API

* Added missing arguments to the "Exists" API
* Added missing parameters to the "Indices Clear Cache" API
* Added missing parameters to the "Indices Delete" API
* Added missing parameters to the "Multi Search" API
* Added missing parameters to the "Search" API
* Added missing parameters to the "Search" API
* Added requirement for the `id` argument for the "Create" API
* Added support for additional parameters to the "Cluster State" API
* Added support for additional parameters to the "Rollover" API
* Added the "Remote Info" API
* Added the "verbose" parameter to the "Get Snapshot" API
* Aded the "Get Task" API
* Changed, that the YAML test content is not printed unless `DEBUG` is set
* Fixed a failing unit test for the "Create Document" API
* Fixed handling of parameters in the "Rollover" API
* Fixed incorrect handling of `catch` clauses in the YAML tests runner
* Fixed incorrect handling of node ID in the "Nodes Stats" API
* Fixed incorrect URL parameter in "Indices Flush" unit test
* Fixed the failing unit tests for "Scroll" APIs
* Fixes for the "Scroll" API
* Updated and improved the YAML test runner

### Client

* Added default value 'application/json' for the 'Content-Type' header
* Added escaping of username and password in URL
* Added proper handling of headers in client options to the Manticore adapter
* Don't block waiting for body on HEAD requests
* Fixed double logging of failed responses
* Fixed incorrect test behaviour when the `QUIET` environment variable is set
* Fixed the bug with `nil` value of `retry_on_status`
* Fixed the incorrect paths and Typhoeus configuration in the benchmark tests
* Fixed the integration tests for client
* Fixed typo in default port handling during `__build_connections`
* Swallow logging of exceptions when the `ignore` is specified

## 5.0.5

### Client

* Added escaping of username and password in URL
* Don't block waiting for body on HEAD requests

### API

* Aded the "Get Task" API
* Fixed handling of parameters in the "Rollover" API
* Added requirement for the `id` argument for the "Create" API
* Added support for additional parameters to the "Rollover" API
* Added support for additional parameters to the "Cluster State" API
* Fixed incorrect handling of `catch` clauses in the YAML tests runner
* Fixed a failing unit test for the "Create Document" API
* Removed unsupported parameters from the "Indices Flush" API
* Added the "Remote Info" API
* Fixed incorrect URL parameter in "Indices Flush" unit test
* Fixed incorrect handling of node ID in the "Nodes Stats" API
* Fix the path for indices exists_type? method & update docs
* Added terminate_after parameter to Count action
* Marked the `percolate` method as deprecated and added an example for current percolator
* Fixed, that `Utils.__report_unsupported_parameters` and `Utils.__report_unsupported_method`
  use `Kernel.warn` so they can be suppressed
* Update the Reindex API to support :slices

### DSL

* Added the `match_phrase` and `match_phrase_prefix` queries
* Removed the `type` field from the "Match" query
* Added an integration test for the "match phrase prefix" query

## 5.0.4

### Client

* Fixed incorrect test behaviour when the `QUIET` environment variable is set
* Fixed double logging of failed responses
* Swallow logging of exceptions when the `ignore` is specified
* Fixed the bug with `nil` value of `retry_on_status`

### API

* Added the "Field Capabilities" API
* Changed, that the YAML test content is not printed unless `DEBUG` is set
* Fixed the failing unit tests for "Scroll" APIs
* Added missing parameters to the "Search" API
* Added missing parameters to the "Multi Search" API
* Added missing parameters to the "Indices Clear Cache" API
* Added missing arguments to the "Exists" API
* Fixes for the "Scroll" API
* Improved the YAML test runner

## 5.0.3

### Client

* Added proper handling of headers in client options to the Manticore adapter

## 5.0.2

### Client

* Added default value 'application/json' for the 'Content-Type' header

## 5.0.0

### API

* Updated the parameters for Elasticsearch 5.x APIs
* Added Elasticsearch 5.x APIs


## EXT:0.0.27

* Allow passing the Elasticsearch version to the Test::Cluster extension
* Improved the profiling extension
* Added that the timeout in `__determine_version` is configurable and increased the default value
* Improved the integration test for the `Test::Cluster` extension
* Improved the test infrastructure
* Added the Elasticsearch start command for the 6.x version to the test/cluster extension
* Added the "oj" and "patron" Rubygem to the list of runtime dependencies

## DSL:0.1.5

* Added support for the ["Exists" Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-exists-query.html)
* Added missing `like` and `unlike` options to the ["More Like This" Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html)
* Added missing `time_zone` option to the ["Query String" Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html)
* Added missing `inner_hits` option to the [Nested Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-nested-query.html)
* Allow calling the `filter` method for the [Bool Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-bool-query.html) multiple times
* Added missing `minimum_should_match`, `prefix_length`, `max_expansions`, `fuzzy_rewrite`, `analyzer`, `lenient`, `zero_terms_query` and `cutoff_frequency` options to the [Match Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-match-query.html)
* Added missing `minimum_should_match` and `boost` options to the [Bool Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-bool-query.html)
* Refactored the [Aggregations](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations.html) collection into its own `AggregationsCollection` class

## EXT:0.0.23

* Fixed removing the data directory for Elasticsearch 5 and 6 in the test cluster
* Added, that Elasticsearch process is properly killed when determining version
* Updated the test cluster class to be compatible Elasticsearch 6.x
* Added `the max_local_storage_nodes` setting to the start command arguments for Elasticsearch 5.x
* Improved the documentation and error messsages for the test cluster
* Updated the "Reindex" extension for Elasticsearch 5.x

## 1.1.3

### Client

* Fixed MRI 2.4 compatibility for 1.x
* Fixed failing integration test for keeping existing collections

## 1.1.0

### API

* Added deprecation notices to API methods and arguments not supported on Elasticsearch 1.x

## 2.0.2

### Client

* * Fixed the bug with `nil` value of `retry_on_status`

### API

* * Added, that `_all` is used as default index in "Search Exists" API
* * Added, that `index` and `type` parameters are respected in the "Search Exists" API

## EXT:2.0.2

* * Updated the `Test::Cluster` extension

## 2.0.0

* Added deprecation notices to API methods and parameters not supported on Elasticsearch 2.x

## DSL:0.1.4

* Added correct implementation of `Sort#empty?`
* Added the `filter` method to the Bool query
* Added the pipeline aggregations
* Allowed access to calling context from search block

## EXT:0.0.22

* Refactored and significantly improved the "Reindex" extension
* Refactored and improved the `Extensions::Test::Cluster` extension

## 1.0.18

* Fixed the incorrect Rake dependency on Ruby 1.8 and updated the Rake dependency to 11.1
* Simplified the main README and added the information about the DSL and Watcher libraries

### API

* Added `ignore: 404` to integration test setup blocks
* Added options to the "Indices Get" and "Indices Flush Synced" APIs
* Added the "Cat Tasks", "Cluster Stats", "Explain allocation", "Ingest", "Reindex" and "Update By Query" APIs
* Added the `:terminate_after` parameter to the "Search" API
* Added the `:timeout` option to the Nodes "Hot Threads", "Info" and "Stats" APIs
* Added the `:timeout` parameter to the Nodes "Hot Threads", "Info" and "Stats" APIs
* Added the `:verbose` option to the "Indices Segments" API and fixed formatting
* Added the `explain` option to the "Analyze" API
* Added the `filter` parameter for the "Indices Analyze" API
* Added the `group_by` option to the "Tasks List" API
* Added the `include_defaults` option to the "Get Cluster Settings" API
* Added the `include_defaults` parameter to the "Indices" APIs
* Added the `preserve_existing` option to the "Indices Put Settings" API
* Added the `request_cache` parameter to the "Search" API
* Added the `retry_failed` option to the "Cluster Reroute" API
* Added the `size` parameter to the "Cat Thread Pool" API
* Added the `update_all_types` parameter to "Indices Create" and "Indices Put Mapping" APIs
* Added the parameters for ingest nodes into the "Bulk" and "Index" APIs
* Fixes and improvements of handling the API method parameters
* Changed, that the "Ping" API returns false also on connection errors (server "not reachable")
* Added a `Utils.__report_unsupported_method` and `Utils.__report_unsupported_parameters` methods

### Client

* Fixed, that the clients tries to deserialize an empty body
* Fixed, that dead connections have not been removed during reloading, leading to leaks

## EXT:0.0.21

* Improved the documentation for the "Backup" extension and added it to the main README
* Added the information about the "Reindex" extension to the README
* Added a reindex extension
* Improved the `Elasticsearch::Extensions::Test::Cluster` extension

## 1.0.17

### Client

* Fixed, that existing connections are not re-initialized during reloading ("sniffing")

## 1.0.16

* Added notes about ES 2.x compatibility
* Fixes and updates to the Travis CI configuration
* Updated the `elasticsearch:build` Rake task

### API

* Added the ability to set a custom JSON serializer
* Added, that`fields` and `fielddata_fields` in the Search API are not escaped
* Fixed the incorrect handling of `:data` keys in the Utils#__bulkify method
* Added fixes to suppress warnings in the verbose mode
* Added support for new Cat API calls

### Client

* Added, that username and password is automatically escaped in the URL
* Changed, that the password is replaced with `*` characters in the log
* Bumped the "manticore" gem dependency to 0.5
* Improved the thread-safety of reloading connections
* Improved the Manticore HTTP client
* Fixed, that connections are reloaded _before_ getting a connection
* Added a better interface for configuring global HTTP settings such as protocol or authentication

## DSL:0.1.3

* Changed, that `global` aggregation takes a block
* Updated the README example to work with Elasticsearch 2.x
* Improved the documentation and integration tests for inner (nested) aggregaation
* Added the option method `field` and `script` to the "stats" aggregation

## EXT:0.0.20

* Fixed the implementation of keeping the test cluster data and state around between restarts

## 1.0.15

* Updated the Travis CI configuration

### API

* Added `bytes` as a valid parameter to "Shards" and "Segments" Cat API
* Added support for the `local` argument in the "Get Warmer" API
* Added support for `fields` argument in the "Get Field Mapping" API
* Fixed an error in the YAML runner handling of ENV['TEST_CLUSTER_PARAMS']
* Validate and extract params from indices.get_warmer arguments

### Client

* Added the option to configure the Faraday adapter using a block and the relevant documentation
* Added information about configuring the client for the Amazon Elasticsearch Service
* Added the `retry_on_status` option to retry on specific HTTP response statuses
* Changed, that transports can close connections during `__rebuild_connections`
* Added, that the Manticore adapter closes connections during reload ("sniffing")

## 1.0.14

* Clarified version support of Elasticsearch
* Improved the `elasticsearch:build` Rake task to work with branch names

### API

* Added support for the `:ignore` option to the "Snapshot and Restore" API
* Added support for the `:ignore` option to the Status API
* Added the "Cat Nodeattrs" API
* Added the "fields" parameter to the Bulk API
* Added the "Render Search Template" API
* Added the "Shard Stores" API
* Added, that document ID is URL-escaped when percolating an existing document
* Allow passing TEST_CLUSTER_PARAMS to the test cluster
* Define the path to core REST tests dynamically based on Elasticsearch version
* Fixed example in "Get Warmer" API
* Fixed incorrect documentation and link in the "Clear Cache" API
* Fixed integration tests for the "Snapshot and Restore" API
* Fixed the incorrect path in "Field Stats" API and added support for the `body` argument
* Fixed, that `type` is not added both to path and URL parameters in the Bulk API
* Updated the examples in README and documentation (facets -> aggregations)

### Client

* Added an argument to control clearing out the testing cluster
* Fixed, that reloading connections works with SSL, authentication and proxy/Shield
* Highlight the need to set `retry_on_failure` option with multiple hosts in documentation

## DSL:0.1.2

* Added fuzziness option to the "Match" query
* Added the `format` option to range filter and query
* Added, that `*args` are passed to the Options initializer

## EXT:0.0.19

* Added `es.path.repo` to the testing cluster
* Added `path_logs` option to test cluster
* Added the `testattr` attribute to the testing cluster
* Changed the default network host for the testing cluster to "localhost", to enable new "multicast"

## 1.0.13

### Client

* Added, that connection reloading supports Elasticsearch 2.0 output
* Improved thread safety in parts of connection handling code

## DSL:1.0.1

* Added additional option methods to the "Multi Match" query

## 1.0.12

### API

* Fixed a regression when rescuing NotFound errors

## 1.0.11

* Fixed incorrect Hash syntax for Ruby 1.8 in client.rb

## 1.0.10

### Client

* Cleaned up handling the `reload_connections` option for transport
* Be more defensive when logging exception
* Added, that the Manticore transport respects the `transport_options` argument
* Added a top level `request_timeout` argument

### API

* Added the "Indices Seal" API
* Added unified/centralized `NotFound` error handling

### Watcher

* Added the integration with Elasticsearch Watcher plugin

## 1.0.9

* Improved the `elasticsearch::build` task in the main Rakefile
* Merged the 'elasticsearch-dsl' gem into the main repository

### Client

* Changed the argument compatibility check in `__extract_hosts()` from `respond_to?` to `is_a?`
* Document the DEFAULT_MAX_RETRIES value for `retry_on_failure`
* Leave only Typhoeus as the primary example of automatically detected & used HTTP library in README
* Make sure the `connections` object is an instance of Collection
* Prevent mutating the parameter passed to __extract_hosts() method
* Removed the `ipv4` resolve mode setting in the Curb adapter
* Update Manticore to utilize new SSL settings
* Updated the Curb integration test to not fail on older Elasticsearch versions

### API

* Added `_source_transform` to the list of permitted parameters
* Added extra valid arguments to "Count" and "Validate Query" APIs
* Improved and extended the YAML integration test suite runner
* Added extra valida parameters to various APIs
* Added the "Cat Plugins", "Field Stats" and "Search Exists" APIs
* Changed, that `:body` parameter is preferred in the "Scroll" and "Clear Scroll" APIs
* Changed, that predicate method variants are used in RDoc code examples
* Fixed spelling mistakes in the documentation

### DSL

* Added the `elasticsearch-dsl` gem

## 1.0.8

* Fixed incorrect dependency specification in the "elasticsearch" wrapper gem

## EXT:0.0.18

* Removed the deprecated options for launching the test cluster
* Added removing the data folder for `cluster_name` to make sure the testing cluster starts green
* Make sure the `cluster_name` argument is not empty/dangerous in test cluster launcher
* Changed, that test cluster is stopped with `INT` rather than `KILL` signal

## 1.0.7

### Client

* Fixed, that the Curb transport passes the `selector_class` option
* Added handling the `::Curl::Err::TimeoutError` exception for Curb transport
* Reworded information about authentication and added example for using SSL certificates
* Added information about the `ELASTICSEARCH_URL` environment variable to the README
* Allow passing multiple URLs separated by a comma to the client
* Fixed an error where passing `host: { ... }` resulted in error in Client#__extract_hosts

### API

* Fixed incorrect escaping of multiple indices in the "Put Alias" API
* Changed the "Scroll" and "Clear Scroll" APIs to send `scroll_id` in the body
* Updated and fixed the `termvectors` API
* Added the `query_cache` URL parameter to the Search API
* Changed frequently used strings into constants
* Removed the "activesupport" development dependency to prevent test error on Ruby 1.8
* Added the "Cat Segments" API
* Updated the code and documentation for the "Cluster State" API
* Fixed incorrect examples for the "Percolate" API
* Added a `Elasticsearch::API.settings` method for accessing module settings
* Added a `Elasticsearch::API.settings[:skip_parameter_validation]` setting support into `__validate_and_extract_params`
* Added `master_timeout` parameters to the "Template Exists" and "Get Template" APIs
* Fixed incorrect encoding of Array parameters
* Added support for the `metric` parameter in the "Nodes Info" API
* Added the skip features to the YAML test runner (stash_in_path,requires_replica)
* Fixed the Ruby 1.8-incompatible syntax in the "Nodes Info" API
* Added question mark versions for predicate methods
* Added, that `indices.delete` accepts the `:ignore` parameter

### Various

* Changed the way elasticsearch/elasticsearch repository is embedded
* Added the `setup` Rake task
* Added chapter about development to the READMEs
* Added the "test-unit" gem for Ruby 2.2
* Fixed the `elasticsearch:build` Rake task

## EXT:0.0.17

### Extensions

* Improved the aesthetics and robustness of the `Test::Cluster#__print_cluster_info` method
* Removed the dependency on the "Backup" gem (using mocks in tests)

## EXT:0.0.16

### Extensions

* Disabled `allocation.disk.threshold_enabled` in the testing cluster
  to prevent tests failing due to low disk space
* Increased the default logging level for the testing cluster to `DEBUG`
* Added basic integration with the Backup gem
* Changed, that `wait_for_green` timeout is configurable with an environment variable

## 1.0.6

### Client

* Added Manticore transport for JRuby platforms
* Fixed, that `ServerError` inherits from `Transport::Error`
* Fix problems with gems on JRuby
* Added the `send_get_body_as` setting

### API

* Added the "Verify Snapshot" API
* Added the "Upgrade Index" API
* Added support for the `realtime` parameter to the Term Vectors APIs
* Fixed `delete_by_query` example in documentation
* Added the support for `metric` URL parameter to the "Reroute" API
* Added the "Get Indices Info" API
* Added support for versioning for the "Put Script" and "Delete Script" APIs

### Extensions

* Added, that `wait_for_green` timeout for test cluster is configurable with environment variable

### Various

* Added Ruby 2.0.0 and updated 2.1 build specification in the Travis configuration

## 1.0.5

### Client

* Added support for automatically connecting to cluster set in the ELASTICSEARCH_URL environment variable
* Improved documentation

### API

* Added the `flat_settings` and `local` parameters to the "Get Template" API

## 1.0.4

### Client

* Updated the parameters list for APIs (percolate, put index)
* Updated the "Indices Stats" API
* Improved the `__extract_parts` utility method

### API

* Fixed incorrect instructions for automatically using Typhoeus as the Faraday adapter
* Fixed, that the Faraday adapter didn't return a correct <Response> object
* Added, that the response body is automatically force-encoded to UTF-8

## 1.0.3

[SKIP]

## 1.0.2

* Improved the `elasticsearch:build` Rake task

### API

* Added more examples into the documentation
* Added missing parameters to the "Search" API
* Added the `force` option to the "Optimize" API
* Added support for `version` and `version_type` parameters in the "Get Document" API
* Added the "Cat Fielddata", "Recovery", "Search Shards", "Search Template", "Snapshot Status" APIs
* Added the `human` parameter to COMMON_QUERY_PARAMS
* Updated the "Index Stats" API to the current implementation

### Transport

* Added, that error requests are properly logged and traced
* Fixed an error where exception was raised too late for error responses

### Extensions

* Enabled the "Benchmark" API on the testing cluster
* Enabled dynamic scripting by default in the test cluster

-----

## 1.0.1

* Updated 0.90/1.0 compatibility notice
* Many improvements for the continuous integration (Travis, Jenkins)
* Improved documentation

### API

* Added the "explain" parameter for `cluster.reroute`

### Transport

* Added auto-detection for Faraday adapter from loaded Rubygems

### Extensions

* Improved the documentation for `Elasticsearch::Extensions::Test::Cluster`
