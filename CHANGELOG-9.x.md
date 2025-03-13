# CHANGELOG 9.x

## Gem

The size of both `elasticsearch` and `elasticsearch-api` gems will be smaller, since some unnecessary files that were being included in the gem have been removed. There's also been a lot of old code cleanup for `9.x`.

The required Ruby version is set to `2.6` to keep compatiblity wit JRuby 9.3. However, we only test the code against currently supported Ruby versions.

## Elasticsearch Serverless

The CI build now runs tests to ensure compatibility with Elasticsearch Serverless. You can use this gem for your Serverless deployments.

## Elasticsearch API

* The source code is now based on `elasticsearch-specification`, so the API documentation is much more detailed and extensive.
* Scroll APIs: Since sending the `scroll_id` as a parameter was deprecated, now it needs to be sent in the body for `clear_scroll`, `scroll`.
* `indices.get_field_mapping` - `:fields` is a required parameter.
* The functions in `utils.rb` that had names starting with double underscore have been renamed to remove these.

### Development

#### Testing

The gem migrated away from the Elasticsearch REST API tests and test runner in CI. We now run the [Elasticsearch Client tests](https://github.com/elastic/elasticsearch-clients-tests/) with the [Elasticsearch Tests Runner](https://github.com/elastic/es-test-runner-ruby). This gives us more control on what we're testing and makes the Buildkite build way faster in Pull Requests and scheduled builds.

#### Rake tasks

* Some old rake tasks that were not being used have been removed. The rest were streamlined, the `es` namespace has been streamlined to make it easier to run Elasticsearch with Docker during development. The `docker` namespace was merged into `es`.
* Elasticsearch's REST API Spec tests can still be ran with `rake test:deprecated:rest_api` and setting the corresponding value for the environment variable `TEST_SUITE` ('platinum' or 'free').
