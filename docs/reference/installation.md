---
mapped_pages:
  - https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/ruby-install.html
---

# Installation [ruby-install]

Install the Rubygem for the latest {{es}} version by using the following command:

```sh
gem install elasticsearch
```

Or add the `elasticsearch` Ruby gem to your Gemfile:

```ruby
gem 'elasticsearch'
```

You can install the Ruby gem for a specific {{es}} version by using the following command:

```sh
gem install elasticsearch -v 7.0.0
```

Or you can add a specific version of {{es}} to your Gemfile:

```ruby
gem 'elasticsearch', '~> 7.0'
```


## {{es}} and Ruby version compatibility [_es_and_ruby_version_compatibility]

The {{es}} client is compatible with currently maintained Ruby versions. We follow Ruby’s own maintenance policy and officially support all currently maintained versions per [Ruby Maintenance Branches](https://www.ruby-lang.org/en/downloads/branches/).

Language clients are forward compatible; meaning that clients support communicating with greater or equal minor versions of {{es}} without breaking. It does not mean that the client automatically supports new features of newer {{es}} versions; it is only possible after a release of a new client version. For example, a 8.12 client version won’t automatically support the new features of the 8.13 version of {{es}}, the 8.13 client version is required for that. {{es}} language clients are only backwards compatible with default distributions and without guarantees made.

| Gem Version |  | {{es}} Version | Supported |
| --- | --- | --- | --- |
| 7.x | → | 7.x | 7.17 |
| 8.x | → | 8.x | 8.x |
| main | → | main |  |

