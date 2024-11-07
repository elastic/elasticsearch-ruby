# CHANGELOG 9.x

## Elasticsearch API

### Development

**Integration Tests**

Migrated away from the Elasticsearch REST API tests and test runner in CI. We now run the [Elasticsearch Client tests](https://github.com/elastic/elasticsearch-clients-tests/) with the [Elasticsearch Tests Runner](https://github.com/elastic/es-test-runner-ruby/**. This gives us more control on what we're testing and makes the Buildkite build way faster in Pull Requests and scheduled builds.


**Rake tasks**

Some old rake tasks that were not being used have been removed. The rest were streamlined, the `es` namespace has been streamlined to make it easier to run Elasticsearch with Docker during development. The `docker` namespace was merged into `es`.
