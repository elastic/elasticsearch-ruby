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

describe Elasticsearch::Client do
  let(:user_agent) {
    "elasticsearch-ruby/#{Elasticsearch::VERSION}; elastic-transport-ruby/#{Elastic::Transport::VERSION}; RUBY_VERSION: #{RUBY_VERSION}; #{RbConfig::CONFIG['host_os'].split('_').first[/[a-z]+/i].downcase} #{RbConfig::CONFIG['target_cpu']}"
  }

  context 'when no user-agent is set on initialization' do
    let(:client) { described_class.new }

    it 'has the expected header' do
      expect(client.transport.options[:transport_options][:headers][:user_agent]).to eq user_agent
    end
  end

  context 'when a header is specified on initialization' do
    let(:client) do
      described_class.new(
        transport_options: { headers: { 'X-Test-Header' => 'Test' } }
      )
    end

    it 'has the expected header' do
      expect(client.transport.options[:transport_options][:headers][:user_agent]).to eq user_agent
      expect(client.transport.options[:transport_options][:headers]['X-Test-Header']).to eq 'Test'
    end
  end

  context 'when other transport_options are specified on initialization' do
    let(:client) do
      described_class.new(
        transport_options: { params:  { format: 'yaml' } }
      )
    end

    it 'has the expected header' do
      expect(client.transport.options[:transport_options][:headers][:user_agent]).to eq user_agent
      expect(client.transport.options[:transport_options][:params][:format]).to eq 'yaml'
    end
  end

  context 'when :user_agent is specified on initialization' do
    let(:client) do
      described_class.new(
        transport_options: { headers: { user_agent: 'TestApp' } }
      )
    end

    it 'has the expected header' do
      expect(client.transport.options[:transport_options][:headers][:user_agent]).to eq 'TestApp'
    end
  end
end
