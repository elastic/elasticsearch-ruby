# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require_relative 'spec_helper'

describe 'Get documentation examples' do
  before(:context) do
    DEFAULT_CLIENT.indices.create(index: 'twitter', body: {
        mappings: {properties: {
            counter: {type: 'integer',
                      store: false},
            tags: {type: 'keyword',
                   store: true}
        }
        }
    })
  end

  after(:context) do
    DEFAULT_CLIENT.indices.delete(index: 'twitter')
  end

  context 'documentation examples' do
    let(:client) do
      DEFAULT_CLIENT
    end

    after do
      client.delete_by_query(index: 'twitter', body: { query: { match_all: {} } })
    end

    it 'executes the example code: - fbcf5078a6a9e09790553804054c36b3' do
      client.index(index: 'twitter', id: 0, body: {})
      # tag::fbcf5078a6a9e09790553804054c36b3[]
      response = client.get(index: 'twitter', id: 0)
      # end::fbcf5078a6a9e09790553804054c36b3[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end

    it 'executes the example code: - 98234499cfec70487cec5d013e976a84' do
      client.index(index: 'twitter', id: 0, body: {})
      # tag::98234499cfec70487cec5d013e976a84[]
      response = client.exists(index: 'twitter', id: 0)
      # end::98234499cfec70487cec5d013e976a84[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end

    it 'executes the example code: - 138ccd89f72aa7502dd9578403dcc589' do
      client.index(index: 'twitter', id: 0, body: {})
      # tag::138ccd89f72aa7502dd9578403dcc589[]
      response = client.get(index: 'twitter', id: 0, _source: false)
      # end::138ccd89f72aa7502dd9578403dcc589[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end

    it 'executes the example code: - 8fdf2344c4fb3de6902ad7c5735270df' do
      client.index(index: 'twitter', id: 0, body: {})
      # tag::8fdf2344c4fb3de6902ad7c5735270df[]
      response = client.get(index: 'twitter', id: 0, _source_includes: '*.id', _source_excludes: 'entities')
      # end::8fdf2344c4fb3de6902ad7c5735270df[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end

    it 'executes the example code: - 745f9b8cdb8e91073f6e520e1d9f8c05' do
      client.index(index: 'twitter', id: 0, body: {})
      # tag::745f9b8cdb8e91073f6e520e1d9f8c05[]
      response = client.get(index: 'twitter', id: 0, _source_includes: '*.id,retweeted')
      # end::745f9b8cdb8e91073f6e520e1d9f8c05[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end

    it 'executes the example code: - 913770050ebbf3b9b549a899bc11060a' do
      client.indices.delete(index: 'twitter')
      # tag::913770050ebbf3b9b549a899bc11060a[]
      response = client.indices.create(index: 'twitter', body: {
          mappings: {properties: {
              counter: {type: 'integer',
                        store: false},
              tags: {type: 'keyword',
                     store: true}
          }
          }
      })
      # end::913770050ebbf3b9b549a899bc11060a[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end

    it 'executes the example code: - 913770050ebbf3b9b549a899bc11060a' do
      # tag::913770050ebbf3b9b549a899bc11060a[]
      response = client.index(index: 'twitter', id: 1, body: {counter: 1, tags: ['red']})
      # end::913770050ebbf3b9b549a899bc11060a[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end

    it 'executes the example code: - 710c7871f20f176d51209b1574b0d61b' do
      client.index(index: 'twitter', id: 1, body: {counter: 1, tags: ['red']})
      # tag::710c7871f20f176d51209b1574b0d61b[]
      response = client.get(index: 'twitter', id: 1, stored_fields: 'tags,counter')
      # end::710c7871f20f176d51209b1574b0d61b[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end

    it 'executes the example code: - 0ba0b2db24852abccb7c0fc1098d566e' do
      # tag::0ba0b2db24852abccb7c0fc1098d566e[]
      response = client.index(index: 'twitter', id: 2, routing: 'user1', body: {counter: 1, tags: ['white']})
      # end::0ba0b2db24852abccb7c0fc1098d566e[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end

    it 'executes the example code: - 69a7be47f85138b10437113ab2f0d72d' do
      client.index(index: 'twitter', id: 2, routing: 'user1', body: {counter: 1, tags: ['white']})
      # tag::69a7be47f85138b10437113ab2f0d72d[]
      response = client.get(index: 'twitter', id: 2, routing: 'user1', stored_fields: 'tags,counter')
      # end::69a7be47f85138b10437113ab2f0d72d[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end

    it 'executes the example code: - 89a8ac1509936acc272fc2d72907bc45' do
      client.index(index: 'twitter', id: 1, body: {counter: 1, tags: ['red']})
      # tag::89a8ac1509936acc272fc2d72907bc45[]
      response = client.get_source(index: 'twitter', id: 1)
      # end::89a8ac1509936acc272fc2d72907bc45[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end

    it 'executes the example code: - d222c6a6ec7a3beca6c97011b0874512' do
      client.index(index: 'twitter', id: 1, body: {counter: 1, tags: ['red']})
      # tag::d222c6a6ec7a3beca6c97011b0874512[]
      response = client.get_source(index: 'twitter', id: 1, _source_includes: '*.id', _source_excludes: 'entities')
      # end::d222c6a6ec7a3beca6c97011b0874512[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end

    it 'executes the example code: - 2468ab381257d759d8a88af1141f6f9c' do
      client.index(index: 'twitter', id: 1, body: {counter: 1, tags: ['red']})
      # tag::2468ab381257d759d8a88af1141f6f9c[]
      response = client.exists_source(index: 'twitter', id: 1, type: '_doc')
      # end::2468ab381257d759d8a88af1141f6f9c[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end

    it 'executes the example code: - 1d65cb6d055c46a1bde809687d835b71' do
      client.index(index: 'twitter', id: 1, routing: 'user1', body: {counter: 1, tags: ['red']})
      # tag::1d65cb6d055c46a1bde809687d835b71[]
      response = client.get(index: 'twitter', id: 1, routing: 'user1')
      # end::1d65cb6d055c46a1bde809687d835b71[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end
  end
end
