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
  context 'when cloud credentials are provided' do
    let(:client) do
      described_class.new(
        cloud_id: 'name:bG9jYWxob3N0JGFiY2QkZWZnaA==',
        user: 'elastic',
        password: 'changeme'
      )
    end

    let(:hosts) do
      client.transport.hosts
    end

    it 'extracts the cloud credentials' do
      expect(hosts[0][:host]).to eq('abcd.localhost')
      expect(hosts[0][:protocol]).to eq('https')
      expect(hosts[0][:user]).to eq('elastic')
      expect(hosts[0][:password]).to eq('changeme')
      expect(hosts[0][:port]).to eq(443)
    end

    it 'creates the correct full url' do
      expect(
        client.transport.__full_url(client.transport.hosts[0])
      ).to eq('https://elastic:changeme@abcd.localhost:443')
    end

    context 'when a port is specified' do
      let(:client) do
        described_class.new(cloud_id: 'name:bG9jYWxob3N0JGFiY2QkZWZnaA==', user: 'elastic', password: 'changeme', port: 9250)
      end

      it 'sets the specified port along with the cloud credentials' do
        expect(hosts[0][:host]).to eq('abcd.localhost')
        expect(hosts[0][:protocol]).to eq('https')
        expect(hosts[0][:user]).to eq('elastic')
        expect(hosts[0][:password]).to eq('changeme')
        expect(hosts[0][:port]).to eq(9250)
      end

      it 'creates the correct full url' do
        expect(client.transport.__full_url(client.transport.hosts[0])).to eq('https://elastic:changeme@abcd.localhost:9250')
      end
    end

    context 'when the cluster has alternate names' do
      let(:client) do
        described_class.new(
          cloud_id: 'myCluster:bG9jYWxob3N0JGFiY2QkZWZnaA==',
          user: 'elasticfantastic',
          password: 'tobechanged'
        )
      end

      let(:hosts) do
        client.transport.hosts
      end

      it 'extracts the cloud credentials' do
        expect(hosts[0][:host]).to eq('abcd.localhost')
        expect(hosts[0][:protocol]).to eq('https')
        expect(hosts[0][:user]).to eq('elasticfantastic')
        expect(hosts[0][:password]).to eq('tobechanged')
        expect(hosts[0][:port]).to eq(443)
      end

      it 'creates the correct full url' do
        expect(
          client.transport.__full_url(client.transport.hosts[0])
        ).to eq('https://elasticfantastic:tobechanged@abcd.localhost:443')
      end
    end

    context 'when decoded cloud id has a trailing dollar sign' do
      let(:client) do
        described_class.new(
          cloud_id: 'a_cluster:bG9jYWxob3N0JGFiY2Qk',
          user: 'elasticfantastic',
          password: 'changeme'
        )
      end

      let(:hosts) do
        client.transport.hosts
      end

      it 'extracts the cloud credentials' do
        expect(hosts[0][:host]).to eq('abcd.localhost')
        expect(hosts[0][:protocol]).to eq('https')
        expect(hosts[0][:user]).to eq('elasticfantastic')
        expect(hosts[0][:password]).to eq('changeme')
        expect(hosts[0][:port]).to eq(443)
      end

      it 'creates the correct full url' do
        expect(
          client.transport.__full_url(client.transport.hosts[0])
        ).to eq('https://elasticfantastic:changeme@abcd.localhost:443')
      end
    end

    context 'when the cloud host provides a port' do
      let(:client) do
        described_class.new(
          cloud_id: 'name:ZWxhc3RpY19zZXJ2ZXI6OTI0MyRlbGFzdGljX2lk',
          user: 'elastic',
          password: 'changeme'
        )
      end

      let(:hosts) do
        client.transport.hosts
      end

      it 'creates the correct full url' do
        expect(hosts[0][:host]).to eq('elastic_id.elastic_server')
        expect(hosts[0][:protocol]).to eq('https')
        expect(hosts[0][:user]).to eq('elastic')
        expect(hosts[0][:password]).to eq('changeme')
        expect(hosts[0][:port]).to eq(9243)
      end
    end

    context 'when the cloud host provides a port and the port is also specified' do
      let(:client) do
        described_class.new(
          cloud_id: 'name:ZWxhc3RpY19zZXJ2ZXI6OTI0MyRlbGFzdGljX2lk',
          user: 'elastic',
          password: 'changeme',
          port: 9200
        )
      end

      let(:hosts) do
        client.transport.hosts
      end

      it 'creates the correct full url' do
        expect(hosts[0][:host]).to eq('elastic_id.elastic_server')
        expect(hosts[0][:protocol]).to eq('https')
        expect(hosts[0][:user]).to eq('elastic')
        expect(hosts[0][:password]).to eq('changeme')
        expect(hosts[0][:port]).to eq(9243)
      end
    end
  end
end
