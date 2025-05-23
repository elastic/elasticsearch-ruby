---
mapped_pages:
  - https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/examples.html
---

# Examples [examples]

Below you can find examples of how to use the most frequently called APIs with the Ruby client.

* [Indexing a document](#ex-index)
* [Getting a document](#ex-get)
* [Updating a document](#ex-update)
* [Deleting a document](#ex-delete)
* [Bulk requests](#ex-bulk)
* [Searching for a document](#ex-search)
* [Multi search](#ex-multisearch)
* [Scrolling](#ex-scroll)
* [Reindexing](#ex-reindex)


## Indexing a document [ex-index]

Let’s index a document with the following fields: `name`, `author`, `release_date`, and `page_count`:

```ruby
body = {
  name: "The Hitchhiker's Guide to the Galaxy",
  author: "Douglas Adams",
  release_date: "1979-10-12",
  page_count: 180
}

client.index(index: 'books', body: body)
```


## Getting a document [ex-get]

You can get a document by ID:

```ruby
id = 'l7LRjXgB2_ry9btNEv_V'
client.get(index: 'books', id: id)
```


## Updating a document [ex-update]

Assume you have the following document:

```ruby
book = {"name": "Foundation", "author": "Isaac Asimov", "release_date": "1951-06-01", "page_count": 224}
```

You can update the document by using the following script:

```ruby
response = client.index(index: 'books', body: book)
id = response['_id']
client.update(index: 'books', id: id, body: { doc: { page_count: 225 } })
```


## Deleting a document [ex-delete]

You can delete a document by ID:

```ruby
id = 'l7LRjXgB2_ry9btNEv_V'
client.delete(index: 'books', id: id)
```


## Bulk requests [ex-bulk]

The `bulk` operation of the client supports various different formats of the payload: array of strings, header/data pairs, or the combined format where data is passed along with the header in a single item in a custom `:data` key.

Index several documents in one request:

```ruby
body = [
  { index: { _index: 'books', _id: '42' } },
  { name: "The Hitchhiker's Guide to the Galaxy", author: 'Douglas Adams', release_date: '1979-10-12', page_count: 180 },
  { index: { _index: 'books', _id: '43' } },
  { name: 'Snow Crash', author: 'Neal Stephenson', release_date: '1992-06-01', page_count: 470 },
  { index: { _index: 'books', _id: '44' } },
  { name: 'Starship Troopers', author: 'Robert A. Heinlein', release_date: '1959-12-01', page_count: 335 }
]
client.bulk(body: body)
```

Delete several documents:

```ruby
body = [
  { delete: { _index: 'books', _id: '42' } },
  { delete: { _index: 'books', _id: '43' } },
]
client.bulk(body: body)
```

As mentioned, you can perform several operations in a single request with the combined format passing data in the `:data` option:

```ruby
body = [
  { index:  { _index: 'books', _id: 45, data: { name: '1984', author: 'George Orwell', release_date: '1985-06-01', page_count: 328 } } },
  { update: { _index: 'books', _id: 43, data: { doc: { page_count: 471 } } } },
  { delete: { _index: 'books', _id: 44  } }
]
client.bulk(body: body)
```


## Searching for a document [ex-search]

This example uses the same data that is used in the [Find structure API documentation](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-text-structure-find-structure).

First, bulk index it:

```ruby
body = [
  { index: { _index: 'books', data: { name: 'Leviathan Wakes', author: 'James S.A. Corey', release_date: '2011-06-02', page_count: 561 } } },
  { index: { _index: 'books', data: { name: 'Hyperion', author: 'Dan Simmons', release_date: '1989-05-26', page_count: 482 } } },
  { index: { _index: 'books', data: { name: 'Dune', author: 'Frank Herbert', release_date: '1965-06-01', page_count: 604 } } },
  { index: { _index: 'books', data: { name: 'Dune Messiah', author: 'Frank Herbert', release_date: '1969-10-15', page_count: 331 } } },
  { index: { _index: 'books', data: { name: 'Children of Dune', author: 'Frank Herbert', release_date: '1976-04-21', page_count: 408 } } },
  { index: { _index: 'books', data: { name: 'God Emperor of Dune', author: 'Frank Herbert', release_date: '1981-05-28', page_count: 454 } } },
  { index: { _index: 'books', data: { name: 'Consider Phlebas', author: 'Iain M. Banks', release_date: '1987-04-23', page_count: 471 } } },
  { index: { _index: 'books', data: { name: 'Pandora\'s Star', author: 'Peter F. Hamilton', release_date: '2004-03-02', page_count: 768 } } },
  { index: { _index: 'books', data: { name: 'Revelation Space', author: 'Alastair Reynolds', release_date: '2000-03-15', page_count: 585 } } },
  { index: { _index: 'books', data: { name: 'A Fire Upon the Deep', author: 'Vernor Vinge', release_date: '1992-06-01', page_count: 613 } } },
  { index: { _index: 'books', data: { name: 'Ender\'s Game', author: 'Orson Scott Card', release_date: '1985-06-01', page_count: 324 } } },
  { index: { _index: 'books', data: { name: '1984', author: 'George Orwell', release_date: '1985-06-01', page_count: 328 } } },
  { index: { _index: 'books', data: { name: 'Fahrenheit 451', author: 'Ray Bradbury', release_date: '1953-10-15', page_count: 227 } } },
  { index: { _index: 'books', data: { name: 'Brave New World', author: 'Aldous Huxley', release_date: '1932-06-01', page_count: 268 } } },
  { index: { _index: 'books', data: { name: 'Foundation', author: 'Isaac Asimov', release_date: '1951-06-01', page_count: 224 } } },
  { index: { _index: 'books', data: { name: 'The Giver', author: 'Lois Lowry', release_date: '1993-04-26', page_count: 208 } } },
  { index: { _index: 'books', data: { name: 'Slaughterhouse-Five', author: 'Kurt Vonnegut', release_date: '1969-06-01', page_count: 275 } } },
  { index: { _index: 'books', data: { name: 'The Hitchhiker\'s Guide to the Galaxy', author: 'Douglas Adams', release_date: '1979-10-12', page_count: 180 } } },
  { index: { _index: 'books', data: { name: 'Snow Crash', author: 'Neal Stephenson', release_date: '1992-06-01', page_count: 470 } } },
  { index: { _index: 'books', data: { name: 'Neuromancer', author: 'William Gibson', release_date: '1984-07-01', page_count: 271 } } },
  { index: { _index: 'books', data: { name: 'The Handmaid\'s Tale', author: 'Margaret Atwood', release_date: '1985-06-01', page_count: 311 } } },
  { index: { _index: 'books', data: { name: 'Starship Troopers', author: 'Robert A. Heinlein', release_date: '1959-12-01', page_count: 335 } } },
  { index: { _index: 'books', data: { name: 'The Left Hand of Darkness', author: 'Ursula K. Le Guin', release_date: '1969-06-01', page_count: 304 } } },
  { index: { _index: 'books', data: { name: 'The Moon is a Harsh Mistress', author: 'Robert A. Heinlein', release_date: '1966-04-01', page_count: 288 } } }
]
client.bulk(body: body)
```

The `field` parameter is a common parameter, so it can be passed in directly in the following way:

```ruby
client.search(index: 'books', q: 'dune')
```

You can do the same by using body request parameters:

```ruby
client.search(index: 'books', q: 'dune', body: { fields: [{ field: 'name' }] })
response = client.search(index: 'books', body: { size: 15 })
response['hits']['hits'].count # => 15
```


## Multi search [ex-multisearch]

The following example shows how to perform a multisearch API call on `books` index:

```ruby
body = [
  {},
  {query: {range: {page_count: {gte: 100}}}},
  {},
  {query: {range: {page_count: {lte: 100}}}}
]
client.msearch(index:'books', body: body)
```


## Scrolling [ex-scroll]

Submit a search API request that includes an argument for the scroll query parameter, save the search ID, then print out the book names you found:

```ruby
# Search request with a scroll argument:
response = client.search(index: 'books', scroll: '10m')

# Save the scroll id:
scroll_id = response['_scroll_id']

# Print out the names of all the books we find:
while response['hits']['hits'].size.positive?
  response = client.scroll(scroll: '5m', body: { scroll_id: scroll_id })
  puts(response['hits']['hits'].map { |r| r['_source']['name'] })
end
```


## Reindexing [ex-reindex]

The following example shows how to reindex the `books` index into a new index called `books-reindexed`:

```ruby
client.reindex(body: {source: { index: 'books'}, dest: {index: 'books-reindexed' } })
```

