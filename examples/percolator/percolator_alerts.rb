# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

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
