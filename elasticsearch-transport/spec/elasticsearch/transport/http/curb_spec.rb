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

unless defined?(JRUBY_VERSION)
  require_relative '../../../spec_helper'

  describe Elasticsearch::Transport::Transport::HTTP::Curb do
    let(:client) do
      Elasticsearch::Transport::Client.new(transport_class: described_class)
    end

    describe '#perform_request' do
      subject(:perform_request) { client.perform_request(*args) }
      let(:args) do
        ['POST', '/', {}, body, headers]
      end
      let(:body) { '{"foo":"bar"}' }
      let(:headers) { { 'Content-Type' => 'application/x-ndjson' } }

      before do
        allow_any_instance_of(Curl::Easy).to receive(:http).and_return(true)
      end

      it 'convert body to json' do
        expect(client.transport).to receive(:__convert_to_json).with(body)
        perform_request
      end

      it 'call compress_request' do
        expect(client.transport).to receive(:compress_request).with(body, headers)
        perform_request
      end

      it 'return response' do
        expect(perform_request).to be_kind_of(Elasticsearch::Transport::Transport::Response)
      end

      it 'put body' do
        expect(client.transport.connections.first.connection).to receive('put_data=').with(body)
        perform_request
      end

      context 'when body nil' do
        let(:body) { nil }

        it 'convert body to json' do
          expect(client.transport).not_to receive(:__convert_to_json)
          perform_request
        end

        it 'call compress_request' do
          expect(client.transport).to receive(:compress_request).with(body, headers)
          perform_request
        end

        it 'put body' do
          expect(client.transport.connections.first.connection).not_to receive('put_data=')
          perform_request
        end
      end

      context 'when body is hash' do
        let(:body) { { foo: 'bar' } }
        let(:body_string) { '{"foo":"bar"}' }

        it 'convert body to json' do
          expect(client.transport).to receive(:__convert_to_json).with(body)
          perform_request
        end

        it 'call compress_request' do
          expect(client.transport).to receive(:compress_request).with(body_string, headers)
          perform_request
        end

        it 'put body' do
          expect(client.transport.connections.first.connection).to receive('put_data=').with(body_string)
          perform_request
        end
      end

      context 'when compression enabled' do
        let(:client) do
          Elasticsearch::Transport::Client.new(transport_class: described_class, compression: true)
        end
        let(:body_string) { '{"foo":"bar"}' }
        let(:compressed_body) do
          gzip = Zlib::GzipWriter.new(StringIO.new)
          gzip << body_string
          gzip.close.string
        end

        before { allow(client.transport).to receive(:decompress_response).and_return('') }

        it 'put compressed body' do
          expect(client.transport.connections.first.connection).to receive('put_data=').with(compressed_body)
          perform_request
        end

        it 'set Content-Encoding header' do
          perform_request
          expect(client.transport.connections.first.connection.headers).to include('Content-Encoding')
        end

        it 'set Content-Encoding to gzip' do
          perform_request
          expect(client.transport.connections.first.connection.headers['Content-Encoding']).to eql('gzip')
        end
      end
    end
  end
end
