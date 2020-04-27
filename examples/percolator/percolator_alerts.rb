# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

# An example of using the percolator with Elasticsearch 5.x and higher
# ====================================================================
#
# See:
#
# * https://www.elastic.co/blog/elasticsearch-percolator-continues-to-evolve
# * https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-percolate-query.html

require 'ansi'
require 'elasticsearch'

client = Elasticsearch::Client.new log: true
client.transport.logger.formatter = proc do |severity, datetime, progname, msg| "\e[2m#{msg}\e[0m\n" end

# Delete the indices used for the example
#
client.indices.delete index: ['my-alerts','my-messages'], ignore: 404

# Set up the mapping for the index
#
# * Register the "percolate" type for the `query` field
# * Set up the mapping for the `message` field
#
client.indices.create index: 'my-alerts',
  body: {
    mappings: {
      doc: {
        properties: {
          query: {
            type: 'percolator'
          },
          message: {
            type: 'text'
          }
        }
      }
    }
  }

# Store alert for messages containing "foo"
#
client.index index: 'my-alerts',
             type: 'doc',
             id: 'alert-1',
             body: { query: { match: { message: 'foo' } } }


# Store alert for messages containing "bar"
#
client.index index: 'my-alerts',
             type: 'doc',
             id: 'alert-2',
             body: { query: { match: { message: 'bar' } } }

# Store alert for messages containing "baz"
#
client.index index: 'my-alerts',
             type: 'doc',
             id: 'alert-3',
             body: { query: { match: { message: 'baz' } } }

client.indices.refresh index: 'my-alerts'

# Percolate a piece of text against the queries
#
results = client.search index: 'my-alerts', body: {
  query: {
    percolate: {
      field: 'query',
      document: {
        message: "Foo Bar"
      }
    }
  }
}

puts "Which alerts match the text 'Foo Bar'?".ansi(:bold),
     '> ' + results['hits']['hits'].map { |r| r['_id'] }.join(', ')

client.index index: 'my-messages', type: 'doc', id: 123, body: { message: "Foo Bar Baz" }

client.indices.refresh index: 'my-messages'

results = client.search index: 'my-alerts', body: {
  query: {
    percolate: {
      field: 'query',
      index: 'my-messages',
      type: 'doc',
      id: 123
    }
  }
}

puts "Which alerts match the document [my-messages/doc/123]?".ansi(:bold),
     '> ' + results['hits']['hits'].map { |r| r['_id'] }.join(', ')
