---
mapped_pages:
  - https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/activemodel_activerecord.html
---

# ActiveModel / ActiveRecord [activemodel_activerecord]

The `elasticsearch-model` [Rubygem](http://rubygems.org/gems/elasticsearch-model) provides integration with Ruby domain objects ("models"), commonly found for example, in Ruby on Rails applications.

It uses the `elasticsearch` Rubygem as the client communicating with the {{es}} cluster.


## Features [_features_2]

* ActiveModel integration with adapters for ActiveRecord and Mongoid
* Enumerable-based wrapper for search results
* ActiveRecord::Relation-based wrapper for returning search results as records
* Convenience model methods such as `search`, `mapping`, `import`, etc
* Support for Kaminari and WillPaginate pagination
* Extension implemented via proxy object to shield model namespace from collisions
* Convenience methods for (re)creating the index, setting up mappings, indexing documents, …​


## Usage [_usage]

Add the library to your Gemfile:

```ruby
gem 'elasticsearch-rails'
```

Include the extension module in your model class:

```ruby
class Article < ActiveRecord::Base
  include Elasticsearch::Model
end
```

Import some data and perform a search:

```ruby
Article.import

response = Article.search 'fox dog'
response.took
# => 3
```

It is possible to either return results as model instances, or decorated documents from {{es}}, with the `records` and `results` methods, respectively:

```ruby
response.records.first
# Article Load (0.4ms)  SELECT "articles".* FROM "articles"  WHERE ...
=> #<Article id: 3, title: "Foo " ...>

response.results.first._score
# => 0.02250402

response.results.first._source.title
# => "Quick brown fox"
```

Consult the [documentation](https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-model) for more information.

