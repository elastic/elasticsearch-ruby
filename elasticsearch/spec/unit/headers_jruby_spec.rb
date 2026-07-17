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
return unless defined?(JRUBY_VERSION)

require 'spec_helper'
require 'ostruct'

describe Elasticsearch::Client do
  context 'Using Manticore with JRuby' do
    let(:client) do
      require 'elastic/transport/transport/http/manticore'
      described_class.new(
        transport_class: Elastic::Transport::Transport::HTTP::Manticore,
        transport_options: { headers: instance_headers }
      ).tap do |client|
        client.instance_variable_set('@verified', true)
      end
    end

    let(:client_headers) do
      client.transport.connections.connections.first.connection.instance_variable_get('@options')[:headers]
    end

    context 'when Content-Type header is used' do
      let(:instance_headers) do
        { 'Content-Type' => 'application/text' }
      end

      it 'does not duplicate the content-type header' do
        expect(client_headers['accept']).to eq 'application/vnd.elasticsearch+json; compatible-with=9'
        expect(client_headers['content-type']).to be nil
        expect(client_headers.fetch('Content-Type')).to eq 'application/text'

        expect_any_instance_of(Manticore::Client)
          .to receive(:get).with(
                'http://localhost:9200/_search',
                { headers: client_headers }
              ) { OpenStruct.new(body: '') }
        client.search
      end

      context 'when content-type header is used' do
        let(:instance_headers) do
          { 'content-type' => 'application/text' }
        end

        it 'does not duplicate the Content-Type header' do
          expect(client_headers['accept']).to eq 'application/vnd.elasticsearch+json; compatible-with=9'
          expect(client_headers['content-type']).to be nil
          expect(client_headers.fetch('Content-Type')).to eq 'application/text'

          expect_any_instance_of(Manticore::Client)
            .to receive(:get).with(
                  'http://localhost:9200/_search',
                  { headers: client_headers }
                ) { OpenStruct.new(body: '') }
          client.search
        end
      end

      context 'when Content-Type is set in request' do
        let(:instance_headers) do
          { 'Content-Type' => 'instance_headers' }
        end
        let(:request_headers) { { 'Content-Type' => 'request headers' } }

        it 'does not duplicate content-type headers' do
          expect_any_instance_of(Manticore::Client)
            .to receive(:get).with(
                  'http://localhost:9200/_search',
                  { headers: client_headers.merge(request_headers) }
                ) { OpenStruct.new(body: '') }
          client.search(headers: request_headers)
          puts client_headers.merge(request_headers)
        end
      end

      context 'when content-type is set in request' do
        let(:instance_headers) do
          { 'Content-Type' => 'instance_headers' }
        end
        let(:request_headers) { { 'content-type' => 'request headers' } }

        it 'does not duplicate content-type headers' do
          expect_any_instance_of(Manticore::Client)
            .to receive(:get).with(
                  'http://localhost:9200/_search',
                  { headers: client_headers.merge(request_headers) }
                ) { OpenStruct.new(body: '') }
          client.search(headers: request_headers)
          puts client_headers.merge(request_headers)
          
        end
      end
    end
  end
end
