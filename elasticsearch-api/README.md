# Elasticsearch::API

*This library is part of the [`elasticsearch-ruby`](https://github.com/elasticsearch/elasticsearch-ruby/) package; please refer to it, unless you want to use this library standalone.*

**Refer to the [official documentation on Elasticsearch API](https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/api.html).**

The `elasticsearch-api` library provides a Ruby implementation of the [Elasticsearch](http://elasticsearch.com) REST API. It does not provide an Elasticsearch client. See [elasticsearch](https://github.com/elastic/elasticsearch-ruby) and the [`elastic-transport`](https://github.com/elastic/elastic-transport-ruby/) libraries for a full Elasticsearch client and HTTP transport layer respectively.

We follow Ruby’s own maintenance policy and officially support all currently maintained versions per [Ruby Maintenance Branches](https://www.ruby-lang.org/en/downloads/branches/).

Language clients are forward compatible; meaning that clients support communicating with greater minor versions of Elasticsearch. Elastic language clients are also backwards compatible with lesser supported minor Elasticsearch versions.


## Development

Refer to [CONTRIBUTING](https://github.com/elastic/elasticsearch-ruby/blob/main/CONTRIBUTING.md).

The integration tests on this project run the [Elasticsearch Client tests](https://github.com/elastic/elasticsearch-clients-tests/) with the [Elasticsearch Tests Runner](https://github.com/elastic/es-test-runner-ruby/) library. This runs in CI against an Elasticsearch cluster in Docker. You can run a docker container with Elasticsearch with a Rake task from the root directory of this project:

```bash
$ rake es:up
```

This will start whatever version of Elasticsearch is set in the Buildkite pipeline file (`../.buildkite/pipeline.yml`) with security enabled. You can also specify a version and a suite ('free' or 'platinum' for security disabled/enabled):

```bash
$ rake es:start[version,suite] # e.g. rake es:start[9.0.0-SNAPSHOT, free]
```

### Code generation

The code for most of this library is automatically generated. See [./utils/README.md](utils/README.md) for more information.

## License

This software is licensed under the [Apache 2 license](./LICENSE).
