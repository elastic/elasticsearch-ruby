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

describe 'client.cluster#health' do

  let(:expected_args) do
    [
        'GET',
        '_cluster/health',
        {},
        nil,
        {},
        { endpoint: 'cluster.health' }
    ]
  end

  it 'performs the request' do
    expect(client_double.cluster.health).to be_a Elasticsearch::API::Response
  end

  context 'when a level is specified' do

    let(:expected_args) do
      [
          'GET',
          '_cluster/health',
          { level: 'indices' },
          nil,
          {},
          { endpoint: 'cluster.health' }
      ]
    end

    it 'performs the request' do
      expect(client_double.cluster.health(level: 'indices')).to be_a Elasticsearch::API::Response
    end
  end

  context 'when an index is specified' do

    let(:expected_args) do
      [
          'GET',
          '_cluster/health/foo',
          {},
          nil,
          {},
          { defined_params: { index: 'foo' }, endpoint: 'cluster.health' }
      ]
    end

    it 'performs the request' do
      expect(client_double.cluster.health(index: 'foo')).to be_a Elasticsearch::API::Response
    end
  end
end
