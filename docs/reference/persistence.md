---
mapped_pages:
  - https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/persistence.html
---

# Persistence [persistence]

The `elasticsearch-persistence` [Rubygem](http://rubygems.org/gems/elasticsearch-persistence) provides persistence layer for Ruby domain objects.

It supports the repository design patterns. Versions before 6.0 also supported the *active record* design pattern.


## Repository [_repository]

The `Elasticsearch::Persistence::Repository` module provides an implementation of the repository pattern and allows to save, delete, find and search objects stored in {{es}}, as well as configure mappings and settings for the index.


### Features [_features_4]

* Access to the {{es}} client
* Setting the index name, document type, and object class for deserialization
* Composing mappings and settings for the index
* Creating, deleting or refreshing the index
* Finding or searching for documents
* Providing access both to domain objects and hits for search results
* Providing access to the {{es}} response for search results
* Defining the methods for serialization and deserialization


### Usage [_usage_2]

Let’s have a simple plain old Ruby object (PORO):

```ruby
class Note
  attr_reader :attributes

  def initialize(attributes={})
    @attributes = attributes
  end

  def to_hash
    @attributes
  end
end
```

Create a default, "dumb" repository, as a first step:

```ruby
require 'elasticsearch/persistence'
class MyRepository; include Elasticsearch::Persistence::Repository; end
repository = MyRepository.new
```

Save a `Note` instance into the repository:

```ruby
note = Note.new id: 1, text: 'Test'

repository.save(note)
# PUT http://localhost:9200/repository/_doc/1 [status:201, request:0.210s, query:n/a]
# > {"id":1,"text":"Test"}
# < {"_index":"repository","_type":"note","_id":"1","_version":1,"created":true}
```

Find it:

```ruby
n = repository.find(1)
# GET http://localhost:9200/repository/_doc/1 [status:200, request:0.003s, query:n/a]
# < {"_index":"repository","_type":"note","_id":"1","_version":2,"found":true, "_source" : {"id":1,"text":"Test"}}
=> <Note:0x007fcbfc0c4980 @attributes={"id"=>1, "text"=>"Test"}>
```

Search for it:

```ruby
repository.search(query: { match: { text: 'test' } }).first
# GET http://localhost:9200/repository/_search [status:200, request:0.005s, query:0.002s]
# > {"query":{"match":{"text":"test"}}}
# < {"took":2, ... "hits":{"total":1, ... "hits":[{ ... "_source" : {"id":1,"text":"Test"}}]}}
=> <Note:0x007fcbfc1c7b70 @attributes={"id"=>1, "text"=>"Test"}>
```

Delete it:

```ruby
repository.delete(note)
# DELETE http://localhost:9200/repository/_doc/1 [status:200, request:0.014s, query:n/a]
# < {"found":true,"_index":"repository","_type":"note","_id":"1","_version":3}
=> {"found"=>true, "_index"=>"repository", "_type"=>"note", "_id"=>"1", "_version"=>2}
```

The repository module provides a number of features and facilities to configure and customize the behaviour, as well as support for extending your own, custom repository class.

Please refer to the [documentation](https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-persistence#the-repository-pattern) for more information.

Also, check out the [example application](https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-persistence#example-application) which demonstrates the usage patterns of the *repository* approach to persistence.

