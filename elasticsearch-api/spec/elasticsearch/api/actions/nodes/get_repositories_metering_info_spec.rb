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

describe 'client.nodes#get_metering_info' do
  let(:expected_args) do
    [
      'GET',
      '_nodes/foo/_repositories_metering',
      {},
      nil,
      {}
    ]
  end

  it 'performs the request' do
    expect(client_double.nodes.get_repositories_metering_info(node_id: 'foo', max_archive_version: 'bar')).to eq({})
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'raises an error if no node_id is provided' do
    expect do
      client.nodes.get_repositories_metering_info
    end.to raise_exception(ArgumentError)
  end
end
