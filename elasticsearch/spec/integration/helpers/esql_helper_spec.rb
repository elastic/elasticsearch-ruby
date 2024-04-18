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
require_relative 'helpers_spec_helper'
require 'elasticsearch/helpers/esql_helper'
require 'ipaddr'

context 'Elasticsearch client helpers' do
  let(:index) { 'esql_helper_test' }
  let(:body) { { size: 12, query: { match_all: {} } } }
  let(:esql_helper) { Elasticsearch::Helpers::ESQLHelper }
  let(:query) do
    <<~ESQL
        FROM #{index}
        | EVAL duration_ms = ROUND(event.duration / 1000000.0, 1)
    ESQL
  end

  before do
    client.indices.create(
      index: index,
      body: {
        mappings: {
          properties: { 'client.ip' => { type: 'ip' }, message: { type: 'keyword' } }
        }
      }
    )
    client.bulk(
      index: index,
      body: [
        {'index': {}},
        {'@timestamp' => '2023-10-23T12:15:03.360Z', 'client.ip' => '172.21.2.162', message: 'Connected to 10.1.0.3', 'event.duration' => 3450233},
        {'index': {}},
        {'@timestamp' => '2023-10-23T12:27:28.948Z', 'client.ip' => '172.21.2.113', message: 'Connected to 10.1.0.2', 'event.duration' => 2764889},
        {'index': {}},
        {'@timestamp' => '2023-10-23T13:33:34.937Z', 'client.ip' => '172.21.0.5', message: 'Disconnected', 'event.duration' => 1232382},
        {'index': {}},
        {'@timestamp' => '2023-10-23T13:51:54.732Z', 'client.ip' => '172.21.3.15', message: 'Connection error', 'event.duration' => 725448},
        {'index': {}},
        {'@timestamp' => '2023-10-23T13:52:55.015Z', 'client.ip' => '172.21.3.15', message: 'Connection error', 'event.duration' => 8268153},
        {'index': {}},
        {'@timestamp' => '2023-10-23T13:53:55.832Z', 'client.ip' => '172.21.3.15', message: 'Connection error', 'event.duration' => 5033755},
        {'index': {}},
        {'@timestamp' => '2023-10-23T13:55:01.543Z', 'client.ip' => '172.21.3.15', message: 'Connected to 10.1.0.1', 'event.duration' => 1756467}
      ],
      refresh: true
    )
  end

  after do
    client.indices.delete(index: index)
  end

  it 'returns an ESQL response as a relational key/value object' do
    response = esql_helper.query(client, query)
    expect(response.count).to eq 7
    expect(response.first.keys).to eq ['duration_ms', 'message', 'event.duration', 'client.ip', '@timestamp']
    response.each do |r|
      expect(r['@timestamp']).to be_a String
      expect(r['client.ip']).to be_a String
      expect(r['message']).to be_a String
      expect(r['event.duration']).to be_a Integer
    end
  end

  it 'parses iterated objects when procs are passed in' do
    parser = {
      '@timestamp' => Proc.new { |t| DateTime.parse(t) },
      'client.ip' => Proc.new { |i| IPAddr.new(i) },
      'event.duration' => Proc.new { |d| d.to_s }
    }
    response = esql_helper.query(client, query, parser: parser)
    response.each do |r|
      expect(r['@timestamp']).to be_a DateTime
      expect(r['client.ip']).to be_a IPAddr
      expect(r['message']).to be_a String
      expect(r['event.duration']).to be_a String
    end
  end

  it 'parser does not error when value is nil, leaves nil' do
    client.index(
      index: index,
      body: {
        '@timestamp' => nil,
        'client.ip' => nil,
        message: 'Connected to 10.1.0.1',
        'event.duration' => 1756465
      },
      refresh: true
    )
    parser = {
      '@timestamp' => Proc.new { |t| DateTime.parse(t) },
      'client.ip' => Proc.new { |i| IPAddr.new(i) },
      'event.duration' => Proc.new { |d| d.to_s }
    }
    response = esql_helper.query(client, query, parser: parser)
    response.each do |r|
      expect [DateTime, NilClass].include?(r['@timestamp'].class)
      expect [IPAddr, NilClass].include?(r['client.ip'].class)
      expect(r['message']).to be_a String
      expect(r['event.duration']).to be_a String
    end
  end
end
