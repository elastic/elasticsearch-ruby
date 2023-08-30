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
require 'ostruct'

describe Elasticsearch::Client do
  context 'when a header is set on an endpoint request' do
    let(:client) { described_class.new }
    let(:headers) { { 'user-agent' => 'my ruby app' } }

    it 'performs the request with the header' do
      allow(client).to receive(:perform_request) { OpenStruct.new(body: '') }
      expect { client.search(headers: headers) }.not_to raise_error
      expect(client).to have_received(:perform_request)
        .with('GET', '_search', {}, nil, headers, { endpoint: 'search' })
    end
  end

  context 'when a header is set on an endpoint request and on initialization' do
    let!(:client) do
      described_class.new(
        host: 'http://localhost:9200',
        transport_options: { headers: instance_headers }
      ).tap do |client|
        client.instance_variable_set('@verified', true)
      end
    end
    let(:instance_headers) { { set_in_instantiation: 'header value' } }
    let(:param_headers) { { 'user-agent' => 'My Ruby Tests', 'set-on-method-call' => 'header value' } }

    it 'performs the request with the header' do
      expected_headers = client.transport.connections.connections.first.connection.headers.merge(param_headers)

      expect_any_instance_of(Faraday::Connection)
        .to receive(:run_request)
          .with(:get, 'http://localhost:9200/_search', nil, expected_headers) { OpenStruct.new(body: '') }

      client.search(headers: param_headers)
    end
  end
end
