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

require 'spec_helper'
require 'uri'

ELASTICSEARCH_URL = ENV['TEST_ES_SERVER'] || "http://localhost:#{(ENV['PORT'] || 9200)}"
raise URI::InvalidURIError unless ELASTICSEARCH_URL =~ /\A#{URI::DEFAULT_PARSER.make_regexp}\z/

context 'Elasticsearch client' do
  let(:client) do
    Elasticsearch::Client.new(host: ELASTICSEARCH_URL, user: 'elastic', password: 'changeme')
  end
  let(:index) { 'tvs' }

  after do
    client.indices.delete(index: index)
  end

  context 'escaping spaces in ids' do
    it 'escapes spaces for id when using index' do
      response = client.index(index: index, id: 'a test 1', body: { name: 'A test 1' }, refresh: true)
      expect(response.body['_id']).to eq 'a test 1'

      response = client.search(index: index)
      expect(response.body['hits']['hits'].first['_id']).to eq 'a test 1'

      # Raises exception, _id is unrecognized
      expect do
        client.index(index: index, _id: 'a test 2', body: { name: 'A test 2' })
      end.to raise_exception Elastic::Transport::Transport::Errors::BadRequest

      # Raises exception, id is a query parameter
      expect do
        client.index(index: index, body: { name: 'A test 3', _id: 'a test 3' })
      end.to raise_exception Elastic::Transport::Transport::Errors::BadRequest
    end

    it 'escapes spaces for id when using create' do
      # Works with create
      response = client.create(index: index, id: 'a test 4', body: { name: 'A test 4' })
      expect(response.body['_id']).to eq 'a test 4'
    end

    it 'escapes spaces for id when using bulk' do
      body = [
        { create: { _index: index, _id: 'a test 5', data: { name: 'A test 5' } } }
      ]
      expect(client.bulk(body: body, refresh: true).status).to eq 200

      response = client.search(index: index)
      expect(
        response.body['hits']['hits'].select { |a| a['_id'] == 'a test 5' }.size
      ).to eq 1
    end
  end

  context 'it doesnae escape plus signs in id' do
    it 'escapes spaces for id when using index' do
      response = client.index(index: index, id: 'a+test+1', body: { name: 'A test 1' })
      expect(response.body['_id']).to eq 'a+test+1'
    end

    it 'escapes spaces for id when using create' do
      # Works with create
      response = client.create(index: index, id: 'a+test+2', body: { name: 'A test 2' })
      expect(response.body['_id']).to eq 'a+test+2'
    end

    it 'escapes spaces for id when using bulk' do
      body = [
        { create: { _index: index, _id: 'a+test+3', data: { name: 'A test 3' } } }
      ]
      expect(client.bulk(body: body, refresh: true).status).to eq 200

      response = client.search(index: index)
      expect(
        response.body['hits']['hits'].select { |a| a['_id'] == 'a+test+3' }.size
      ).to eq 1
    end
  end
end
