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

describe 'client.indices#delete_alias' do
  context 'when there is no name specified' do
    let(:expected_args) do
      [
        'GET',
        '_resolve/cluster',
        {},
        nil,
        {},
        { endpoint: 'indices.resolve_cluster' }
      ]
    end

    it 'performs the request' do
      expect(client_double.indices.resolve_cluster).to be_a Elasticsearch::API::Response
    end
  end

  context 'when name is specified' do
    let(:expected_args) do
      [
        'GET',
        '_resolve/cluster/foo',
        {},
        nil,
        {},
        { defined_params: { name: 'foo' }, endpoint: 'indices.resolve_cluster' }
      ]
    end

    it 'performs the request' do
      expect(client_double.indices.resolve_cluster(name: 'foo')).to be_a Elasticsearch::API::Response
    end
  end
end
