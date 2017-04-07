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
