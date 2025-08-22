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

describe 'msearrch_template headers test' do
  context 'when not setting headers' do
    let(:client) do
      Elasticsearch::Client.new
    end

    let(:expected_headers) do
      {
        'accept' => 'application/vnd.elasticsearch+x-ndjson; compatible-with=9',
        'content-type' => 'application/vnd.elasticsearch+x-ndjson; compatible-with=9'
      }
    end

    it 'does not override headers' do
      allow(client)
        .to receive(:perform_request)
              .with(
                Elasticsearch::API::HTTP_POST,
                '_msearch/template',
                {},
                {},
                expected_headers,
                { endpoint: 'msearch_template' }
              )
      expect(client.msearch_template(body: {})).to be_a Elasticsearch::API::Response
    end
  end

  context 'when using compatibility headers for version 8' do
    let(:client) do
      Elasticsearch::Client.new(
        transport_options: {
          headers: custom_headers
        }
      )
    end

    let(:custom_headers) do
      {
        accept: 'application/vnd.elasticsearch+json; compatible-with=8',
        content_type: 'application/vnd.elasticsearch+json; compatible-with=8'
      }
    end

    let(:expected_headers) do
      {
        accept: 'application/vnd.elasticsearch+x-ndjson; compatible-with=8',
        content_type: 'application/vnd.elasticsearch+x-ndjson; compatible-with=8'
      }
    end

    it 'does not override version in headers' do
      allow(client)
        .to receive(:perform_request)
        .with(
          Elasticsearch::API::HTTP_POST,
          '_msearch/template',
          {},
          {},
          expected_headers,
          { endpoint: 'msearch_template' }
        )
      expect(client.msearch_template(body: {})).to be_a Elasticsearch::API::Response
    end
  end

  context 'when using custom headers in request' do
    let(:client) do
      Elasticsearch::Client.new(
        transport_options: {
          headers: custom_headers
        }
      )
    end

    let(:custom_headers) do
      {
        accept: 'application/vnd.elasticsearch+json; compatible-with=8',
        content_type: 'application/vnd.elasticsearch+json; compatible-with=8'
      }
    end

    let(:expected_headers) do
      {
        accept: 'application/vnd.elasticsearch+x-ndjson; compatible-with=8',
        content_type: 'application/vnd.elasticsearch+x-ndjson; compatible-with=8',
        x_custom: 'Custom header'
      }
    end

    it 'does not override version in headers' do
      allow(client)
        .to receive(:perform_request)
              .with(
                Elasticsearch::API::HTTP_POST,
                '_msearch/template',
                {},
                {},
                expected_headers,
                { endpoint: 'msearch_template' }
              )
      expect(client.msearch_template(body: {}, headers: { x_custom: 'Custom header' })).to be_a Elasticsearch::API::Response
    end
  end
end
