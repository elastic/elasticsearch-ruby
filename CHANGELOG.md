*To see release notes for the `7.x` branch and older releases, see [CHANGELOG on the 7.17 branch](https://github.com/elastic/elasticsearch-ruby/blob/7.17/CHANGELOG.md).*

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
