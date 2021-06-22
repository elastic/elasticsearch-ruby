# Elasticsearch::XPack

----
⚠ **This library is deprecated** ⚠

The API endpoints currently living in `elasticsearch-xpack` will be moved into `elasticsearch-api` in version 8.0.0 and forward. You should be able to keep using `elasticsearch-xpack` and the `xpack` namespace in `7.x`. We're running the same tests in `elasticsearch-xpack`, but if you encounter any problems, please let us know [in this issue](https://github.com/elastic/elasticsearch-ruby/issues/1274).

However, be aware in `8.0`, the xpack library and namespace won't be available anymore.

----

A Ruby integration for the [X-Pack extension](https://www.elastic.co/guide/en/x-pack/current/xpack-introduction.html) for Elasticsearch.

## Installation

Install the package from [Rubygems](https://rubygems.org):

    gem install elasticsearch-api

## Usage

If you use the official [Ruby client for Elasticsearch](https://github.com/elastic/elasticsearch-ruby), all the methods will be automatically available:

```ruby
require 'elasticsearch'

client = Elasticsearch::Client.new(url: 'http://elastic:changeme@localhost:9200')

client.xpack.info
# => {"build"=> ..., "features"=> ...}
```

The integration is designed as a standalone `Elasticsearch::XPack::API` module, so it's easy to mix it into a different client, and the methods will be available in the top namespace.

For documentation, look into the RDoc annotations in the source files, which contain links to the official [X-Pack for the Elastic Stack](https://www.elastic.co/guide/en/x-pack/current/index.html) documentation.

For examples, look into the [`examples`](examples) folder in this repository.

You can use the provided `test:elasticsearch` Rake task to launch a [Docker-based](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html) Elasticsearch node with the full X-Pack license preinstalled.

## License

This software is licensed under the [Apache 2 license](./LICENSE).
