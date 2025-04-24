**See the full release notes on the official documentation website: https://www.elastic.co/docs/release-notes/elasticsearch/clients/ruby**

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
