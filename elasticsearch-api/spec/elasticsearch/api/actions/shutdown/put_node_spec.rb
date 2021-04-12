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

describe 'client.shutdown#put_node' do
  let(:expected_args) do
    [
      'PUT',
      '_nodes/id/shutdown',
      {},
      {},
      {}
    ]
  end

  it 'performs the request' do
    expect(client_double.shutdown.put_node(body: {}, node_id: 'id')).to eq({})
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'raises an error if no node_id is provided' do
    expect {
      client.shutdown.put_node(body: {})
    }.to raise_exception(ArgumentError)
  end

  it 'raises an error if no body is provided' do
    expect {
      client.shutdown.put_node(node_id: 'id')
    }.to raise_exception(ArgumentError)
  end
end
