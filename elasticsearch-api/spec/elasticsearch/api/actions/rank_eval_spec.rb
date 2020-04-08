# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#rank_eval' do

  let(:expected_args) do
    [
        'GET',
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
      expect(client.rank_eval(index: 'my_index', body: {})).to eq({})
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

    it 'performs the request' do
      expect(client_double.rank_eval(body: {},
                                     ignore_unavailable: true,
                                     allow_no_indices: false,
                                     expand_wildcards: 'open')).to eq({})
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
                                         })).to eq({})
    end
  end
end
