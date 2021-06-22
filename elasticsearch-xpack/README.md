# Elasticsearch::XPack

----
⚠ **This library is deprecated** ⚠

The API endpoints currently living in `elasticsearch-xpack` have been moved into `elasticsearch-api`. You should be able to keep using `elasticsearch-xpack` and the `xpack` namespace in `7.x`. We're running the same tests in `elasticsearch-xpack` to make sure we didn't break backwards compatibility during the transition stage, but if you encounter any problems, please let us know [in this issue](https://github.com/elastic/elasticsearch-ruby/issues/1274).

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

## License

This software is licensed under the [Apache 2 license](./LICENSE).
