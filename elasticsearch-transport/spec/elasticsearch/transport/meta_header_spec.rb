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
    let(:client) do
      described_class.new.tap do |klient|
        allow(klient).to receive(:__build_connections)
      end
    end
    let(:subject) { client.transport.connections.first.connection.headers }
    let(:regexp) { /^[a-z]{1,}=[a-z0-9.\-]{1,}(?:,[a-z]{1,}=[a-z0-9.\-]+)*$/ }
    let(:meta_header) do
      if RUBY_ENGINE == 'jruby'
        "es=#{Elasticsearch::VERSION},rb=#{RUBY_VERSION},t=#{Elasticsearch::Transport::VERSION},jr=#{JRUBY_VERSION}"
      else
        "es=#{Elasticsearch::VERSION},rb=#{RUBY_VERSION},t=#{Elasticsearch::Transport::VERSION}"
      end
    end

    context 'single use of meta header' do
      it 'x-elastic-client-header value matches regexp' do
        expect(subject['x-elastic-client-meta']).to match(regexp)
        expect(subject).to include('x-elastic-client-meta' => meta_header)
      end
    end

    context 'when using user-agent headers' do
      let(:client) do
        transport_options = { headers: { user_agent: 'My Ruby App' } }
        described_class.new(transport_options: transport_options).tap do |klient|
          allow(klient).to receive(:__build_connections)
        end
      end

      it 'is friendly to previously set headers' do
        expect(subject).to include(user_agent: 'My Ruby App')
        expect(subject).to include('x-elastic-client-meta' => meta_header)
      end
    end

    context 'when using API Key' do
      let(:client) do
        described_class.new(api_key: 'an_api_key')
      end

      let(:authorization_header) do
        client.transport.connections.first.connection.headers['Authorization']
      end

      it 'Adds the ApiKey header to the connection' do
        expect(authorization_header).to eq('ApiKey an_api_key')
        expect(subject['x-elastic-client-meta']).to match(regexp)
      end
    end
  end
end
