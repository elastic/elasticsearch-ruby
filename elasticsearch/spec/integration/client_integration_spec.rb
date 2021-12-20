# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
ELASTICSEARCH_URL = ENV['TEST_ES_SERVER'] || "http://localhost:#{(ENV['PORT'] || 9200)}"
raise URI::InvalidURIError unless ELASTICSEARCH_URL =~ /\A#{URI::DEFAULT_PARSER.make_regexp}\z/

require 'spec_helper'
require 'logger'

context 'Elasticsearch client' do
  let(:logger) { Logger.new($stderr) }

  let(:client) do
    Elasticsearch::Client.new(
      host: ELASTICSEARCH_URL,
      logger: logger,
      user: 'elastic',
      password: 'changeme'
    )
  end

  context 'Integrates with elasticsearch API' do
    it 'should perform the API methods' do
      expect do
        # Index a document
        client.index(index: 'test-index', id: '1', body: { title: 'Test' })

        # Refresh the index
        client.indices.refresh(index: 'test-index')

        # Search
        response = client.search(index: 'test-index', body: { query: { match: { title: 'test' } } })

        expect(response['hits']['total']['value']).to eq 1
        expect(response['hits']['hits'][0]['_source']['title']).to eq 'Test'

        # Delete the index
        client.indices.delete(index: 'test-index')
      end.not_to raise_error
    end
  end

  context 'Reports the right meta header' do
    it 'Reports es service name and gem versio' do
      headers = client.transport.connections.first.connection.headers
      version = Class.new.extend(Elastic::Transport::MetaHeader).send(:client_meta_version, Elasticsearch::VERSION)
      expect(headers['x-elastic-client-meta']).to match /^es=#{version}/
    end
  end
end
