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

describe 'client.indices#clone' do

  let(:expected_args) do
    [
        'PUT',
        url,
        params,
        body,
        {}
    ]
  end

  let(:params) do
    {}
  end

  let(:body) do
    nil
  end

  let(:url) do
    'my_source_index/_clone/my_target_index'
  end

  context 'when there is no index specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.clone(target: 'my_target_index')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when there is no index specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.clone(index: 'my_source_index')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when an index and target are specified' do

    it 'performs the request' do
      expect(client_double.indices.clone(index: 'my_source_index', target: 'my_target_index')).to eq({})
    end
  end

  context 'when params are provided' do

    let(:params) do
      {
          timeout: '1s',
          master_timeout: '10s',
          wait_for_active_shards: 1
      }
    end

    it 'performs the request' do
      expect(client_double.indices.clone(index: 'my_source_index',
                                         target: 'my_target_index',
                                         timeout: '1s',
                                         master_timeout: '10s',
                                         wait_for_active_shards: 1)).to eq({})
    end
  end

  context 'when a body is specified' do

    let(:body) do
      {
          settings: {
              'index.number_of_shards' => 5
          },
          aliases: {
              my_search_indices: {}
          }
      }
    end

    it 'performs the request' do
      expect(client_double.indices.clone(index: 'my_source_index',
                                         target: 'my_target_index',
                                         body: {
                                             settings: {
                                                 'index.number_of_shards' => 5
                                             },
                                             aliases: {
                                                 my_search_indices: {}
                                             }
                                         })).to eq({})
    end
  end
end
