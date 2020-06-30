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

describe Elasticsearch::Transport::Transport::Sniffer do
  let(:transport) do
    double('transport').tap do |t|
      allow(t).to receive(:perform_request).and_return(response)
      allow(t).to receive(:options).and_return(sniffer_timeout: 2)
    end
  end

  let(:sniffer) do
    described_class.new(transport)
  end

  let(:response) do
    double('response').tap do |r|
      allow(r).to receive(:body).and_return(raw_response)
    end
  end

  let(:raw_response) do
    { 'nodes' => { 'n1' => { 'http' => { 'publish_address' => publish_address } } } }
  end

  let(:publish_address) do
    '127.0.0.1:9250'
  end

  describe '#initialize' do
    it 'has a transport instance' do
      expect(sniffer.transport).to be(transport)
    end

    it 'inherits the sniffer timeout from the transport object' do
      expect(sniffer.timeout).to eq(2)
    end
  end

  describe '#timeout' do
    let(:sniffer) do
      described_class.new(double('transport', options: {}))
    end

    before do
      sniffer.timeout = 3
    end

    it 'allows the timeout to be configured' do
      expect(sniffer.timeout).to eq(3)
    end
  end

  describe '#hosts' do
    let(:hosts) do
      sniffer.hosts
    end

    context 'when the entire response is parsed' do
      let(:raw_response) do
        {
          "cluster_name" => "elasticsearch_test",
          "nodes" => {
              "N1" => {
                "name" => "Node 1",
                "transport_address" => "127.0.0.1:9300",
                "host" => "testhost1",
                "ip"   => "127.0.0.1",
                "version" => "7.0.0",
                "roles" => [
                  "master",
                  "data",
                  "ingest"
                ],
                "attributes" => {
                  "testattr" => "test"
                },
                "http" => {
                  "bound_address" => [
                    "[fe80::1]:9250",
                    "[::1]:9250",
                    "127.0.0.1:9250"
                  ],
                "publish_address" => "127.0.0.1:9250",
                "max_content_length_in_bytes" => 104857600
                }
              }
          }
        }
      end

      it 'parses the id' do
        expect(sniffer.hosts[0][:id]).to eq('N1')
      end

      it 'parses the name' do
        expect(sniffer.hosts[0][:name]).to eq('Node 1')
      end

      it 'parses the version' do
        expect(sniffer.hosts[0][:version]).to eq('7.0.0')
      end

      it 'parses the host' do
        expect(sniffer.hosts[0][:host]).to eq('127.0.0.1')
      end

      it 'parses the port' do
        expect(sniffer.hosts[0][:port]).to eq('9250')
      end

      it 'parses the roles' do
        expect(sniffer.hosts[0][:roles]).to eq(['master',
                                                'data',
                                                'ingest'])
      end

      it 'parses the attributes' do
        expect(sniffer.hosts[0][:attributes]).to eq('testattr' => 'test')
      end
    end

    context 'when the transport protocol does not match' do
      let(:raw_response) do
        { 'nodes' => { 'n1' => { 'foo' => { 'publish_address' => '127.0.0.1:9250' } } } }
      end

      it 'does not parse the addresses' do
        expect(hosts).to eq([])
      end
    end

    context 'when a list of nodes is returned' do
      let(:raw_response) do
        { 'nodes' => { 'n1' => { 'http' => { 'publish_address' => '127.0.0.1:9250' } },
                       'n2' => { 'http' => { 'publish_address' => '127.0.0.1:9251' } } } }
      end

      it 'parses the response' do
        expect(hosts.size).to eq(2)
      end

      it 'correctly parses the hosts' do
        expect(hosts[0][:host]).to eq('127.0.0.1')
        expect(hosts[1][:host]).to eq('127.0.0.1')
      end

      it 'correctly parses the ports' do
        expect(hosts[0][:port]).to eq('9250')
        expect(hosts[1][:port]).to eq('9251')
      end
    end

    context 'when the host and port are an ip address and port' do
      it 'parses the response' do
        expect(hosts.size).to eq(1)
      end

      it 'correctly parses the host' do
        expect(hosts[0][:host]).to eq('127.0.0.1')
      end

      it 'correctly parses the port' do
        expect(hosts[0][:port]).to eq('9250')
      end
    end

    context 'when the host and port are a hostname and port' do
      let(:publish_address) do
        'testhost1.com:9250'
      end

      let(:hosts) do
        sniffer.hosts
      end

      it 'parses the response' do
        expect(hosts.size).to eq(1)
      end

      it 'correctly parses the host' do
        expect(hosts[0][:host]).to eq('testhost1.com')
      end

      it 'correctly parses the port' do
        expect(hosts[0][:port]).to eq('9250')
      end
    end

    context 'when the host and port are in the format: hostname/ip:port' do
      let(:publish_address) do
        'example.com/127.0.0.1:9250'
      end

      it 'parses the response' do
        expect(hosts.size).to eq(1)
      end

      it 'uses the hostname' do
        expect(hosts[0][:host]).to eq('example.com')
      end

      it 'correctly parses the port' do
        expect(hosts[0][:port]).to eq('9250')
      end

      context 'when the address is IPv6' do
        let(:publish_address) do
          'example.com/[::1]:9250'
        end

        it 'parses the response' do
          expect(hosts.size).to eq(1)
        end

        it 'uses the hostname' do
          expect(hosts[0][:host]).to eq('example.com')
        end

        it 'correctly parses the port' do
          expect(hosts[0][:port]).to eq('9250')
        end
      end
    end

    context 'when the address is IPv6' do
      let(:publish_address) do
        '[::1]:9250'
      end

      it 'parses the response' do
        expect(hosts.size).to eq(1)
      end

      it 'correctly parses the host' do
        expect(hosts[0][:host]).to eq('::1')
      end

      it 'correctly parses the port' do
        expect(hosts[0][:port]).to eq('9250')
      end
    end

    context 'when the transport has :randomize_hosts option' do
      let(:raw_response) do
        { 'nodes' => { 'n1' => { 'http' => { 'publish_address' => '127.0.0.1:9250' } },
                       'n2' => { 'http' => { 'publish_address' => '127.0.0.1:9251' } } } }
      end

      before do
        allow(transport).to receive(:options).and_return(randomize_hosts: true)
      end

      it 'shuffles the list' do
        expect(hosts.size).to eq(2)
      end
    end
  end
end
