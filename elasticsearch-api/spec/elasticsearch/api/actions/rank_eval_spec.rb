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

describe 'client#rank_eval' do

  let(:expected_args) do
    [
      'POST',
      url,
      params,
      body,
      {},
      { defined_params: { index: 'my_index' }, endpoint: 'rank_eval' }
    ]
  end

  let(:params) do
    {}
  end

  let(:body) do
    {}
  end

  let(:url) do
    '_rank_eval'
  end

  context 'when there is no body specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.rank_eval(index: 'my_index')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when an index is specified' do

    let(:url) do
      'my_index/_rank_eval'
    end

    it 'performs the request' do
      expect(client.rank_eval(index: 'my_index', body: {})).to be_a Elasticsearch::API::Response
    end
  end

  context 'when params are provided' do

    let(:params) do
      {
          ignore_unavailable: true,
          allow_no_indices: false,
          expand_wildcards: 'open'
      }
    end

    let(:expected_args) do
      [
        'POST',
        url,
        params,
        body,
        {},
        { endpoint: 'rank_eval' }
      ]
    end

    it 'performs the request' do
      expect(client_double.rank_eval(body: {},
                                     ignore_unavailable: true,
                                     allow_no_indices: false,
                                     expand_wildcards: 'open')).to be_a Elasticsearch::API::Response
    end
  end

  context 'when a body is specified' do

    let(:body) do
      {
          "requests": [
              {
                  "id": "JFK query",
                  "request": { "query": { "match_all": {}}},
                  "ratings": []
              }],
          "metric": {
              "expected_reciprocal_rank": {
                  "maximum_relevance": 3,
                  "k": 20
              }
          }
      }
    end

    let(:url) do
      'my_index/_rank_eval'
    end

    it 'performs the request' do
      expect(client_double.rank_eval(index: 'my_index',
                                         body: {
                                             "requests": [
                                                 {
                                                     "id": "JFK query",
                                                     "request": { "query": { "match_all": {}}},
                                                     "ratings": []
                                                 }],
                                             "metric": {
                                                 "expected_reciprocal_rank": {
                                                     "maximum_relevance": 3,
                                                     "k": 20
                                                 }
                                             }
                                         })).to be_a Elasticsearch::API::Response
    end
  end
end
