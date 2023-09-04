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

describe 'client#searchable_snapshots.clear_cache' do
  let(:expected_args) do
    [
      'POST',
      url,
      {},
      nil,
      {},
      { endpoint: 'searchable_snapshots.clear_cache' }
    ]
  end

  let(:url){ '_searchable_snapshots/cache/clear' }

  it 'performs the request' do
    expect(client_double.searchable_snapshots.clear_cache).to be_a Elasticsearch::API::Response
  end

  context 'when using index' do
    let(:url){ 'foo/_searchable_snapshots/cache/clear' }

    let(:expected_args) do
      [
        'POST',
        url,
        {},
        nil,
        {},
        { defined_params: { index: 'foo' },
          endpoint: 'searchable_snapshots.clear_cache' }
      ]
    end

    it 'performs the request' do
      expect(client_double.searchable_snapshots.clear_cache(index: 'foo')).to be_a Elasticsearch::API::Response
    end
  end
end
