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
require 'base64'

describe Elasticsearch::Client do
  context 'when using API Key' do
    let(:authorization_header) do
      client.transport.connections.first.connection.headers['Authorization']
    end

    context 'when an encoded api_key is provided' do
      let(:client) do
        described_class.new(api_key: 'an_api_key')
      end

      it 'Adds the ApiKey header to the connection' do
        expect(authorization_header).to eq('ApiKey an_api_key')
      end
    end

    context 'when an un-encoded api_key is provided' do
      let(:client) do
        described_class.new(api_key: { id: 'my_id', api_key: 'my_api_key' })
      end

      it 'Adds the ApiKey header to the connection' do
        expect(authorization_header).to eq("ApiKey #{Base64.strict_encode64('my_id:my_api_key')}")
      end
    end

    context 'when basic auth and api_key are provided' do
      let(:client) do
        described_class.new(
          api_key: { id: 'my_id', api_key: 'my_api_key' },
          host: 'http://elastic:password@localhost:9200'
        )
      end

      it 'removes basic auth credentials' do
        expect(authorization_header).not_to match(/^Basic/)
        expect(authorization_header).to match(/^ApiKey/)
      end
    end

    context 'when other headers were specified' do
      let(:client) do
        described_class.new(
          api_key: 'elasticsearch_api_key',
          transport_options: { headers: { 'x-test-header' => 'test' } }
        )
      end

      it 'Adds the ApiKey header to the connection and keeps the header' do
        header = client.transport.connections.first.connection.headers
        expect(header['Authorization']).to eq('ApiKey elasticsearch_api_key')
        expect(header['X-Test-Header']).to eq('test')
      end
    end

    context 'when sending transport_options but no headers were specified' do
      let(:client) do
        described_class.new(
          api_key: 'elasticsearch_api_key',
          transport_options: { ssl: { verify: false } }
        )
      end

      it 'Adds the ApiKey header to the connection and keeps the options' do
        header = client.transport.connections.first.connection.headers
        expect(header['Authorization']).to eq('ApiKey elasticsearch_api_key')
        expect(client.transport.options[:transport_options]).to include({ ssl: { verify: false } })
        expect(client.transport.options[:transport_options][:headers]).to include('Authorization' => 'ApiKey elasticsearch_api_key')
      end
    end

    context 'when other headers and options were specified' do
      let(:client) do
        described_class.new(
          api_key: 'elasticsearch_api_key',
          transport_options: {
            headers: { 'x-test-header' => 'test' },
            ssl: { verify: false }
          }
        )
      end

      it 'Adds the ApiKey header to the connection and keeps the header' do
        header = client.transport.connections.first.connection.headers
        expect(header['X-Test-Header']).to eq('test')
        expect(header['Authorization']).to eq('ApiKey elasticsearch_api_key')
        expect(client.transport.options[:transport_options]).to include({ ssl: { verify: false } })
        expect(client.transport.options[:transport_options][:headers]).to include('Authorization' => 'ApiKey elasticsearch_api_key')
      end
    end

    context 'Metaheader' do
      let(:adapter_code) { "nh=#{defined?(Net::HTTP::VERSION) ? Net::HTTP::VERSION : Net::HTTP::HTTPVersion}" }
      let(:meta_header) do
        if jruby?
          "es=#{meta_version},rb=#{RUBY_VERSION},t=#{Elastic::Transport::VERSION},jv=#{ENV_JAVA['java.version']},jr=#{JRUBY_VERSION},fd=#{Faraday::VERSION},#{adapter_code}"
        else
          "es=#{meta_version},rb=#{RUBY_VERSION},t=#{Elastic::Transport::VERSION},fd=#{Faraday::VERSION},#{adapter_code}"
        end
      end

      context 'when using API Key' do
        let(:client) do
          described_class.new(api_key: 'an_api_key')
        end

        let(:headers) do
          client.transport.connections.first.connection.headers
        end

        it 'adds the ApiKey header to the connection' do
          expect(authorization_header).to eq('ApiKey an_api_key')
          expect(headers).to include('x-elastic-client-meta' => meta_header)
        end
      end
    end
  end
end
