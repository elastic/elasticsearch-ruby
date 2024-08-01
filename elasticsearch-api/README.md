# Elasticsearch::API

*This library is part of the [`elasticsearch-ruby`](https://github.com/elasticsearch/elasticsearch-ruby/) package; please refer to it, unless you want to use this library standalone.*

**Refer to the [official documentation on Elasticsearch API](https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/api.html).**

The `elasticsearch-api` library provides a Ruby implementation of the [Elasticsearch](http://elasticsearch.com) REST API. It does not provide an Elasticsearch client; see the [`elastic-transport`](https://github.com/elastic/elastic-transport-ruby/) library.

We follow Ruby’s own maintenance policy and officially support all currently maintained versions per [Ruby Maintenance Branches](https://www.ruby-lang.org/en/downloads/branches/).

Language clients are forward compatible; meaning that clients support communicating with greater minor versions of Elasticsearch. Elastic language clients are also backwards compatible with lesser supported minor Elasticsearch versions.


## Development

Refer to [CONTRIBUTING](https://github.com/elastic/elasticsearch-ruby/blob/main/CONTRIBUTING.md).

We run the test suite for Elasticsearch's Rest API tests. You can read more about this in [the test runner README](https://github.com/elastic/elasticsearch-ruby/tree/main/api-spec-testing#rest-api-yaml-test-runner).

The `rest_api` task needs the test files from Elasticsearch. You can run the rake task to download the test artifacts in the root folder of the project. You can pass in a version to the task as a parameter:

`rake download_artifacts[8.5.0-SNAPSHOT]`

Or it can get the version from a running cluster to determine which version and build hash of Elasticsearch to use and test against:

`TEST_ES_SERVER=http://localhost:9200 rake es:download_artifacts`

This will download the necessary files used for the integration tests to `./tmp`.

### Code generation

The code for most of this library is automatically generated. See [./utils/README.md](utils/README.md) for more information.

## License

This software is licensed under the [Apache 2 license](./LICENSE).
