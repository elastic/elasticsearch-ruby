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

describe 'client#delete_by_query' do

  let(:expected_args) do
    [
      'POST',
      'foo/_delete_by_query',
      {},
      { term: {} },
      {}
    ]
  end

  it 'requires the :index argument' do
    expect {
      Class.new { include Elasticsearch::API }.new.delete_by_query(body: {})
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.delete_by_query(index: 'foo', body: { term: {} })).to eq({})
  end

  context 'when the type argument is provided' do

    let(:expected_args) do
      [
        'POST',
        'foo/tweet,post/_delete_by_query',
        {},
        { term: {} },
        {}
      ]
    end

    it 'performs the request' do
      expect(client_double.delete_by_query(index: 'foo', type: ['tweet', 'post'], body: { term: {} })).to eq({})
    end
  end

  context 'when a query is provided' do
    let(:expected_args) do
      [
        'POST',
        'foo/_delete_by_query',
        { q: 'foo:bar' },
        { query: 'query' },
        {}
      ]
    end

    it 'performs the request' do
      expect(
        client_double.delete_by_query(
          index: 'foo',
          q: 'foo:bar',
          body: { query: 'query' }
        )
      ).to eq({})
    end
  end
end
