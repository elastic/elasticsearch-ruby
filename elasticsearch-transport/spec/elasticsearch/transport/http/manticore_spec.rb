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

if defined?(JRUBY_VERSION)
  require_relative '../../../spec_helper'

  describe Elasticsearch::Transport::Transport::HTTP::Manticore do
    let(:client) do
      Elasticsearch::Transport::Client.new(transport_class: described_class)
    end

    describe '#perform_request' do
      subject(:perform_request) { client.perform_request(*args) }
      let(:args) do
        ['POST', '/', {}, body, headers]
      end
      let(:body) { '{"foo":"bar"}' }
      let(:headers) { { 'Content-Type' => 'application/json' } }
      let(:response) { instance_double('Manticore::Response', code: 200, read_body: '', headers: headers) }
      let(:expected_headers) do
        client.transport.instance_variable_get('@request_options')[:headers].merge(headers)
      end

      before do
        allow_any_instance_of(Manticore::Client).to receive(:post).and_return(response)
      end

      it 'convert body to json' do
        expect(client.transport).to receive(:__convert_to_json).with(body)
        perform_request
      end

      it 'call compress_request' do
        expect(client.transport).to receive(:compress_request).with(body, expected_headers)
        perform_request
      end

      it 'return response' do
        expect(perform_request).to be_kind_of(Elasticsearch::Transport::Transport::Response)
      end

      it 'run body with preper params' do
        expect(
          client.transport.connections.first.connection
        ).to receive(:post).with('http://localhost:9200/', { body: body, headers: expected_headers }).and_return(response)
        perform_request
      end

      context 'when body nil' do
        let(:body) { nil }
        let(:request_params) { ['http://localhost:9200/', { body: body, headers: expected_headers }] }

        it 'convert body to json' do
          expect(client.transport).not_to receive(:__convert_to_json)
          perform_request
        end

        it 'call compress_request' do
          expect(client.transport).to receive(:compress_request).with(body, expected_headers)
          perform_request
        end

        it 'run body with preper params' do
          expect(
            client.transport.connections.first.connection
          ).to receive(:post).with('http://localhost:9200/', { headers: expected_headers }).and_return(response)
          perform_request
        end
      end

      context 'when body is hash' do
        let(:body) { { foo: 'bar' } }
        let(:body_string) { '{"foo":"bar"}' }
        let(:request_params) { ['http://localhost:9200/', { body: body_string, headers: expected_headers }] }

        it 'convert body to json' do
          expect(client.transport).to receive(:__convert_to_json).with(body)
          perform_request
        end

        it 'call compress_request' do
          expect(client.transport).to receive(:compress_request).with(body_string, expected_headers)
          perform_request
        end

        it 'run body with preper params' do
          expect(
            client.transport.connections.first.connection
          ).to receive(:post).with(*request_params).and_return(response)
          perform_request
        end
      end

      context 'when compression enabled' do
        let(:client) do
          Elasticsearch::Transport::Client.new(transport_class: described_class, compression: true)
        end
        let(:body_string) { '{"foo":"bar"}' }
        let(:expected_headers) { super().merge({ "Content-Encoding" => "gzip", "Accept-Encoding" => "gzip"}) }
        let(:request_params) { ['http://localhost:9200/', { body: compressed_body, headers: expected_headers }] }
        let(:compressed_body) do
          gzip = Zlib::GzipWriter.new(StringIO.new)
          gzip << body_string
          gzip.close.string
        end

        it 'run body with preper params' do
          expect(
            client.transport.connections.first.connection
          ).to receive(:post).with(*request_params).and_return(response)
          perform_request
        end

        context 'when client makes second request with nil boby' do
          before { perform_request }

          it 'remove Content-Encoding header' do
            expected_headers.delete("Content-Encoding")
            expect(
              client.transport.connections.first.connection
            ).to receive(:post).with('http://localhost:9200/', { headers: expected_headers })
                                      .and_return(response)
            client.perform_request('POST', '/', {}, nil, headers)
          end
        end
      end
    end
  end
end
