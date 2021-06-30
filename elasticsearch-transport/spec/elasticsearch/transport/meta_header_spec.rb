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
require 'elasticsearch'

describe Elasticsearch::Transport::Client do
  context 'meta-header' do
    let(:subject) { client.transport.connections.first.connection.headers }
    let(:client) { described_class.new }
    let(:regexp) { /^[a-z]{1,}=[a-z0-9.\-]{1,}(?:,[a-z]{1,}=[a-z0-9._\-]+)*$/ }
    let(:adapter) { :net_http }
    let(:adapter_code) { "nh=#{defined?(Net::HTTP::VERSION) ? Net::HTTP::VERSION : Net::HTTP::HTTPVersion}" }
    let(:meta_header) do
      if jruby?
        "es=#{meta_version},rb=#{RUBY_VERSION},t=#{Elasticsearch::Transport::VERSION},jv=#{ENV_JAVA['java.version']},jr=#{JRUBY_VERSION},fd=#{Faraday::VERSION},#{adapter_code}"
      else
        "es=#{meta_version},rb=#{RUBY_VERSION},t=#{Elasticsearch::Transport::VERSION},fd=#{Faraday::VERSION},#{adapter_code}"
      end
    end

    context 'client_meta_version' do
      let(:version) { ['7.1.0-alpha', '7.11.0.pre.1', '8.0.0-beta', '8.0.0.beta.2']}

      it 'converts the version to X.X.Xp' do
        expect(client.send(:client_meta_version, '7.0.0-alpha')).to eq('7.0.0p')
        expect(client.send(:client_meta_version, '7.11.0.pre.1')).to eq('7.11.0p')
        expect(client.send(:client_meta_version, '8.1.0-beta')).to eq('8.1.0p')
        expect(client.send(:client_meta_version, '8.0.0.beta.2')).to eq('8.0.0p')
        expect(client.send(:client_meta_version, '12.16.4.pre')).to eq('12.16.4p')
      end
    end

    # We are testing this method in the previous block, so now using it inside the test to make the
    # Elasticsearch version in the meta header string dynamic
    def meta_version
      client.send(:client_meta_version, Elasticsearch::VERSION)
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
        if jruby?
          "es=#{meta_version},rb=#{RUBY_VERSION},t=#{Elasticsearch::Transport::VERSION},jv=#{ENV_JAVA['java.version']},jr=#{JRUBY_VERSION},fd=#{Faraday::VERSION}"
        else
          "es=#{meta_version},rb=#{RUBY_VERSION},t=#{Elasticsearch::Transport::VERSION},fd=#{Faraday::VERSION}"
        end
      end
      let(:client) { described_class.new(adapter: adapter) }
      let(:headers) { client.transport.connections.first.connection.headers }

      context 'using net/http/persistent' do
        let(:adapter) { :net_http_persistent }

        it 'sets adapter in the meta header version to 0 when not loaded' do
          was_required = defined?(Net::HTTP::Persistent)
          if was_required
            @klass = Net::HTTP::Persistent.clone
            Net::HTTP.send(:remove_const, :Persistent)
          end

          expect(headers['x-elastic-client-meta']).to match(regexp)
          meta = "#{meta_header},np=0"
          expect(headers).to include('x-elastic-client-meta' => meta)

          Net::HTTP::Persistent = @klass if was_required
        end unless jruby?

        it 'sets adapter in the meta header' do
          require 'net/http/persistent'
          expect(headers['x-elastic-client-meta']).to match(regexp)
          meta = "#{meta_header},np=#{Net::HTTP::Persistent::VERSION}"
          expect(headers).to include('x-elastic-client-meta' => meta)
        end
      end

      context 'using httpclient' do
        let(:adapter) { :httpclient }

        it 'sets adapter in the meta header version to 0 when not loaded' do
          was_required = defined?(HTTPClient)
          if was_required
            @klass = HTTPClient.clone
            Object.send(:remove_const, :HTTPClient)
          end

          expect(headers['x-elastic-client-meta']).to match(regexp)
          meta = "#{meta_header},hc=0"
          expect(headers).to include('x-elastic-client-meta' => meta)

          HTTPClient = @klass if was_required
        end unless jruby?

        it 'sets adapter in the meta header' do
          require 'httpclient'

          expect(headers['x-elastic-client-meta']).to match(regexp)
          meta = "#{meta_header},hc=#{HTTPClient::VERSION}"
          expect(headers).to include('x-elastic-client-meta' => meta)
        end
      end

      context 'using typhoeus' do
        let(:adapter) { :typhoeus }

        it 'sets adapter in the meta header version to 0 when not loaded' do
          was_required = defined?(Typhoeus)
          if was_required
            @klass = Typhoeus.clone
            Object.send(:remove_const, :Typhoeus)
          end

          expect(headers['x-elastic-client-meta']).to match(regexp)
          meta = "#{meta_header},ty=0"
          expect(headers).to include('x-elastic-client-meta' => meta)

          Typhoeus = @klass if was_required
        end unless jruby?

        it 'sets adapter in the meta header' do
          require 'typhoeus'
          expect(headers['x-elastic-client-meta']).to match(regexp)
          meta = "#{meta_header},ty=#{Typhoeus::VERSION}"
          expect(headers).to include('x-elastic-client-meta' => meta)
        end
      end

      unless jruby?
        let(:adapter) { :patron }

        context 'using patron without requiring it' do
          it 'sets adapter in the meta header version to 0 when not loaded' do
            was_required = defined?(Patron)
            if was_required
              @klass = Patron.clone
              Object.send(:remove_const, :Patron)
            end

            expect(headers['x-elastic-client-meta']).to match(regexp)
            meta = "#{meta_header},pt=0"
            expect(headers).to include('x-elastic-client-meta' => meta)

            Patron = @klass if was_required
          end
        end

        context 'using patron' do
          it 'sets adapter in the meta header' do
            require 'patron'
            expect(headers['x-elastic-client-meta']).to match(regexp)
            meta = "#{meta_header},pt=#{Patron::VERSION}"
            expect(headers).to include('x-elastic-client-meta' => meta)
          end
        end
      end

      context 'using other' do
        let(:adapter) { :some_other_adapter }

        it 'sets adapter in the meta header without requiring' do
          Faraday::Adapter.register_middleware some_other_adapter: Faraday::Adapter::NetHttpPersistent
          expect(headers['x-elastic-client-meta']).to match(regexp)
          expect(headers).to include('x-elastic-client-meta' => meta_header)
        end

        it 'sets adapter in the meta header' do
          require 'net/http/persistent'
          Faraday::Adapter.register_middleware some_other_adapter: Faraday::Adapter::NetHttpPersistent
          expect(headers['x-elastic-client-meta']).to match(regexp)
          expect(headers).to include('x-elastic-client-meta' => meta_header)
        end
      end
    end

    if defined?(JRUBY_VERSION)
      context 'when using manticore' do
        let(:client) do
          described_class.new(transport_class: Elasticsearch::Transport::Transport::HTTP::Manticore).tap do |client|
            client.instance_variable_set('@verified', true)
          end
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
          described_class.new(transport_class: Elasticsearch::Transport::Transport::HTTP::Curb).tap do |client|
            client.instance_variable_set('@verified', true)
          end
        end

        it 'sets curb in the metaheader' do
          expect(subject['x-elastic-client-meta']).to match(regexp)
          expect(subject['x-elastic-client-meta']).to match(/cl=[0-9.]+/)
        end
      end
    end

    context 'when using custom transport implementation' do
      let(:transport_class) do
        Class.new do
          def initialize(args)
          end
        end
      end
      let(:client) { Elasticsearch::Transport::Client.new(transport_class: transport_class) }
      let(:subject) { client.instance_variable_get('@arguments')[:transport_options][:headers] }
      let(:meta_header) do
        if jruby?
          "es=#{meta_version},rb=#{RUBY_VERSION},t=#{Elasticsearch::Transport::VERSION},jv=#{ENV_JAVA['java.version']},jr=#{JRUBY_VERSION}"
        else
          "es=#{meta_version},rb=#{RUBY_VERSION},t=#{Elasticsearch::Transport::VERSION}"
        end
      end

      it 'doesnae set any info about the implementation in the metaheader' do
        expect(subject['x-elastic-client-meta']).to match(regexp)
        expect(subject).to include('x-elastic-client-meta' => meta_header)
      end
    end

    context 'when using a different service version' do
      before do
        stub_const('Elastic::ELASTICSEARCH_SERVICE_VERSION', [:ent, '8.0.0'])
      end

      let(:client) do
        described_class.new.tap do |client|
          client.instance_variable_set('@verified', true)
        end
      end

      it 'sets the service version in the metaheader' do
        expect(subject['x-elastic-client-meta']).to match(regexp)
        expect(subject['x-elastic-client-meta']).to start_with('ent=8.0.0')
      end
    end
  end
end
