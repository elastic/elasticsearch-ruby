---
mapped_pages:
  - https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/getting-started-ruby.html
  - https://www.elastic.co/guide/en/serverless/current/elasticsearch-ruby-client-getting-started.html
---

# Getting started [getting-started-ruby]

This page guides you through the installation process of the Ruby client, shows you how to instantiate the client, and how to perform basic Elasticsearch operations with it.


### Requirements [_requirements]

A currently maintained version of Ruby (3.0+) or JRuby (9.3+).


### Installation [_installation]

To install the latest version of the client, run the following command:

```shell
gem install elasticsearch
```

Refer to the [*Installation*](/reference/installation.md) page to learn more.


### Connecting [_connecting]

You can connect to the Elastic Cloud using an API key and the Elasticsearch endpoint.

```rb
client = Elasticsearch::Client.new(
  cloud_id: '<CloudID>',
  api_key: '<ApiKey>'
)
```

Your Elasticsearch endpoint can be found on the **My deployment** page of your deployment:

:::{image} ../images/es_endpoint.jpg
:alt: Finding Elasticsearch endpoint
:::

You can generate an API key on the **Management** page under Security.

:::{image} ../images/create_api_key.png
:alt: Create API key
:::

For other connection options, refer to the [*Connecting*](/reference/connecting.md) section.


### Operations [_operations]

Time to use Elasticsearch! This section walks you through the basic, and most important, operations of Elasticsearch. For more operations and more advanced examples, refer to the [*Examples*](/reference/examples.md) page.


#### Creating an index [_creating_an_index]

This is how you create the `my_index` index:

```rb
client.indices.create(index: 'my_index')
```


#### Indexing documents [_indexing_documents]

This is a simple way of indexing a document:

```rb
document = { name: 'elasticsearch-ruby' }
response = client.index(index: 'my_index', body: document)
# You can get the indexed document id with:
response['_id']
=> "PlgIDYkBWS9Ngdx5IMy-"
id = response['_id']
```


#### Getting documents [_getting_documents]

You can get documents by using the following code:

```rb
client.get(index: 'my_index', id: id)
```


#### Searching documents [_searching_documents]

This is how you can create a single match query with the Ruby client:

```rb
client.search(index: 'my_index', body: { query: { match_all: {} } })
```


#### Updating documents [_updating_documents]

This is how you can update a document, for example to add a new field:

```rb
client.update(index: 'my_index', id: id, body: { doc: { language: 'Ruby' } })
```


#### Deleting documents [_deleting_documents]

```rb
client.delete(index: 'my_index', id: id)
```


#### Deleting an index [_deleting_an_index]

```rb
client.indices.delete(index: 'my_index')
```


## Further reading [_further_reading]

* Use [Bulk and Scroll helpers](/reference/Helpers.md) for a more confortable experience with the APIs.
