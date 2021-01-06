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

describe Elasticsearch::Transport::Client do
  context 'meta-header' do
    let(:subject) { client.transport.connections.first.connection.headers }
    let(:regexp) { /^[a-z]{1,}=[a-z0-9.\-]{1,}(?:,[a-z]{1,}=[a-z0-9.\-]+)*$/ }
    let(:adapter) { :net_http }
    let(:adapter_code) { "nh=#{defined?(Net::HTTP::VERSION) ? Net::HTTP::VERSION : Net::HTTP::HTTPVersion}" }
    let(:meta_header) do
      if RUBY_ENGINE == 'jruby'
        "es=#{Elasticsearch::VERSION},rb=#{RUBY_VERSION},t=#{Elasticsearch::Transport::VERSION},jr=#{JRUBY_VERSION},fd=#{Faraday::VERSION},#{adapter_code}"
      else
        "es=#{Elasticsearch::VERSION},rb=#{RUBY_VERSION},t=#{Elasticsearch::Transport::VERSION},fd=#{Faraday::VERSION},#{adapter_code}"
      end
    end

    context 'single use of meta header' do
      let(:client) do
        described_class.new(adapter: adapter).tap do |klient|
          allow(klient).to receive(:__build_connections)
        end
      end

      it 'x-elastic-client-header value matches regexp' do
        expect(subject['x-elastic-client-meta']).to match(regexp)
        expect(subject).to include('x-elastic-client-meta' => meta_header)
      end
    end

    context 'when using user-agent headers' do
      let(:client) do
        transport_options = { headers: { user_agent: 'My Ruby App' } }
        described_class.new(transport_options: transport_options, adapter: adapter).tap do |klient|
          allow(klient).to receive(:__build_connections)
        end
      end

      it 'is friendly to previously set headers' do
        expect(subject).to include(user_agent: 'My Ruby App')
        expect(subject['x-elastic-client-meta']).to match(regexp)
        expect(subject).to include('x-elastic-client-meta' => meta_header)
      end
    end

    context 'when using API Key' do
      let(:client) do
        described_class.new(api_key: 'an_api_key', adapter: adapter)
      end

      let(:authorization_header) do
        client.transport.connections.first.connection.headers['Authorization']
      end

      it 'adds the ApiKey header to the connection' do
        expect(authorization_header).to eq('ApiKey an_api_key')
        expect(subject['x-elastic-client-meta']).to match(regexp)
        expect(subject).to include('x-elastic-client-meta' => meta_header)
      end
    end

    context 'adapters' do
      let(:meta_header) do
        if RUBY_ENGINE == 'jruby'
          "es=#{Elasticsearch::VERSION},rb=#{RUBY_VERSION},t=#{Elasticsearch::Transport::VERSION},jr=#{JRUBY_VERSION},fd=#{Faraday::VERSION}"
        else
          "es=#{Elasticsearch::VERSION},rb=#{RUBY_VERSION},t=#{Elasticsearch::Transport::VERSION},fd=#{Faraday::VERSION}"
        end
      end
      let(:client) { described_class.new(adapter: adapter) }
      let(:headers) { client.transport.connections.first.connection.headers }

      context 'using net/http/persistent' do
        let(:adapter) { :net_http_persistent }

        it 'sets adapter in the meta header' do
          require 'net/http/persistent'
          expect(headers['x-elastic-client-meta']).to match(regexp)
          meta = "#{meta_header},np=#{Net::HTTP::Persistent::VERSION}"
          expect(headers).to include('x-elastic-client-meta' => meta)
        end
      end

      context 'using httpclient' do
        let(:adapter) { :httpclient }

        it 'sets adapter in the meta header' do
          require 'httpclient'
          expect(headers['x-elastic-client-meta']).to match(regexp)
          meta = "#{meta_header},hc=#{HTTPClient::VERSION}"
          expect(headers).to include('x-elastic-client-meta' => meta)
        end
      end

      context 'using typhoeus' do
        let(:adapter) { :typhoeus }

        it 'sets adapter in the meta header' do
          require 'typhoeus'
          expect(headers['x-elastic-client-meta']).to match(regexp)
          meta = "#{meta_header},ty=#{Typhoeus::VERSION}"
          expect(headers).to include('x-elastic-client-meta' => meta)
        end
      end

      unless defined?(JRUBY_VERSION)
        let(:adapter) { :patron }

        context 'using patron' do
          it 'sets adapter in the meta header' do
            require 'patron'
            expect(headers['x-elastic-client-meta']).to match(regexp)
            meta = "#{meta_header},pt=#{Patron::VERSION}"
            expect(headers).to include('x-elastic-client-meta' => meta)
          end
        end
      end
    end

    if defined?(JRUBY_VERSION)
      context 'when using manticore' do
        let(:client) do
          Elasticsearch::Client.new(transport_class: Elasticsearch::Transport::Transport::HTTP::Manticore)
        end
        let(:subject) { client.transport.connections.first.connection.instance_variable_get("@options")[:headers]}

        it 'sets manticore in the metaheader' do
          expect(subject['x-elastic-client-meta']).to match(regexp)
          expect(subject['x-elastic-client-meta']).to match(/mc=[0-9.]+/)
        end
      end
    else
      context 'when using curb' do
        let(:client) do
          Elasticsearch::Client.new(transport_class: Elasticsearch::Transport::Transport::HTTP::Curb)
        end

        it 'sets curb in the metaheader' do
          expect(subject['x-elastic-client-meta']).to match(regexp)
          expect(subject['x-elastic-client-meta']).to match(/cl=[0-9.]+/)
        end
      end
    end

    context 'when using custom transport implementation' do
      class MyTransport
        include Elasticsearch::Transport::Transport::Base
        def initialize(args); end
      end
      let(:client) { Elasticsearch::Client.new(transport_class: MyTransport) }
      let(:subject){ client.instance_variable_get("@arguments")[:transport_options][:headers] }
      let(:meta_header) do
        if RUBY_ENGINE == 'jruby'
          "es=#{Elasticsearch::VERSION},rb=#{RUBY_VERSION},t=#{Elasticsearch::Transport::VERSION},jr=#{JRUBY_VERSION}"
        else
          "es=#{Elasticsearch::VERSION},rb=#{RUBY_VERSION},t=#{Elasticsearch::Transport::VERSION}"
        end
      end

      it 'doesnae set any info about the implementation in the metaheader' do
        expect(subject['x-elastic-client-meta']).to match(regexp)
        expect(subject).to include('x-elastic-client-meta' => meta_header)
      end
    end
  end
end
