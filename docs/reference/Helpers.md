---
mapped_pages:
  - https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/Helpers.html
---

# Bulk and Scroll helpers [Helpers]

The {{es}} Ruby client includes Bulk and Scroll helpers for working with results more efficiently.


## Bulk helper [_bulk_helper]

The Bulk API in Elasticsearch allows you to perform multiple indexing or deletion operations through a single API call, resulting in reduced overhead and improved indexing speed. The actions are specified in the request body using a newline delimited JSON (NDJSON) structure. In the Elasticsearch Ruby client, the `bulk` method supports several data structures as a parameter. You can use the Bulk API in an idiomatic way without concerns about payload formatting. Refer to [Bulk requests](/reference/examples.md#ex-bulk) for more information.

The BulkHelper provides a better developer experience when using the Bulk API. At its simplest, you can send it a collection of hashes in an array, and it will bulk ingest them into {{es}}.

To use the BulkHelper, require it in your code:

```ruby
require 'elasticsearch/helpers/bulk_helper'
```

Instantiate a BulkHelper with a client, and an index:

```ruby
client = Elasticsearch::Client.new
bulk_helper = Elasticsearch::Helpers::BulkHelper.new(client, index)
```

This helper works on the index you pass in during initialization, but you can change the index at any time in your code:

```ruby
bulk_helper.index = 'new_index'
```

If you want to index a collection of documents, use the `ingest` method:

```ruby
documents = [
  { name: 'document1', date: '2024-05-16' },
  { name: 'document2', date: '2023-12-19' },
  { name: 'document3', date: '2024-07-07' }
]
bulk_helper.ingest(documents)
```

If you’re ingesting a large set of data and want to separate the documents into smaller pieces before sending them to {{es}}, use the `slice` parameter.

```ruby
bulk_helper.ingest(documents, { slice: 2 })
```

This way the data will be sent in two different bulk requests.

You can also include the parameters you would send to the Bulk API either in the query parameters or in the request body. The method signature is `ingest(docs, params = {}, body = {}, &block)`. Additionally, the method can be called with a block, that will provide access to the response object received from calling the Bulk API and the documents sent in the request:

```ruby
helper.ingest(documents) { |_, docs| puts "Ingested #{docs.count} documents" }
```

You can update and delete documents with the BulkHelper too. To delete a set of documents, you can send an array of document ids:

```ruby
ids = ['shm0I4gB6LpJd9ljO9mY', 'sxm0I4gB6LpJd9ljO9mY', 'tBm0I4gB6LpJd9ljO9mY', 'tRm0I4gB6LpJd9ljO9mY', 'thm0I4gB6LpJd9ljO9mY', 'txm0I4gB6LpJd9ljO9mY', 'uBm0I4gB6LpJd9ljO9mY', 'uRm0I4gB6LpJd9ljO9mY', 'uhm0I4gB6LpJd9ljO9mY', 'uxm0I4gB6LpJd9ljO9mY']
helper.delete(ids)
```

To update documents, you can send the array of documents with their respective ids:

```ruby
documents = [
  {name: 'updated name 1', id: 'AxkFJYgB6LpJd9ljOtr7'},
  {name: 'updated name 2', id: 'BBkFJYgB6LpJd9ljOtr7'}
]
helper.update(documents)
```


### Ingest a JSON file [_ingest_a_json_file]

`BulkHelper` also provides a helper to ingest data straight from a JSON file. By giving a file path as an input, the helper will parse and ingest the documents in the file:

```ruby
file_path = './data.json'
helper.ingest_json(file_path)
```

In cases where the array of data you want to ingest is not necessarily in the root of the JSON file, you can provide the keys to access the data, for example given the following JSON file:

```json
{
  "field": "value",
  "status": 200,
  "data": {
    "items": [
      {
        "name": "Item 1",
        (...)
      },
      {
      (...)
    ]
  }
}
```

The following is an example of the Ruby code to ingest the documents in the JSON above:

```ruby
bulk_helper.ingest_json(file_path, { keys: ['data', 'items'] })
```


## Scroll helper [_scroll_helper]

This helper provides an easy way to get results from a Scroll.

To use the ScrollHelper, require it in your code:

```ruby
require 'elasticsearch/helpers/scroll_helper'
```

Instantiate a ScrollHelper with a client, an index, and a body (with the scroll API parameters) which will be used in every following scroll request:

```ruby
client = Elasticsearch::Client.new
scroll_helper = Elasticsearch::Helpers::ScrollHelper.new(client, index, body)
```

There are two ways to get the results from a scroll using the helper.

1. You can iterate over a scroll using the methods in `Enumerable` such as `each` and `map`:

    ```ruby
    scroll_helper.each do |item|
      puts item
    end
    ```

2. You can fetch results by page, with the `results` function:

    ```ruby
    my_documents = []
    while !(documents = scroll_helper.results).empty?
      my_documents << documents
    end
    scroll_helper.clear
    ```


