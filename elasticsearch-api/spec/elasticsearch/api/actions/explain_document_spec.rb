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

describe 'client#explain' do
  let(:expected_args) do
    [
      method,
      url,
      params,
      body,
      {}
    ]
  end

  let(:method) { 'POST' }

  let(:params) do
    {}
  end

  let(:body) do
    {}
  end

  let(:url) do
    'foo/bar/1/_explain'
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :index argument' do
    expect {
      client.explain(type: 'bar', id: '1')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :id argument' do
    expect {
      client.explain(index: 'foo', type: 'bar')
    }.to raise_exception(ArgumentError)
  end
  
  it 'performs the request' do
    expect(client_double.explain(index: 'foo', type: 'bar', id: 1, body: {})).to eq({})
  end

  context 'when a query is provided' do
    let(:method) { 'GET' }
    let(:params) do
      { q: 'abc123' }
    end

    let(:body) do
      nil
    end

    it 'passes the query' do
      expect(client_double.explain(index: 'foo', type: 'bar', id: '1', q: 'abc123')).to eq({})
    end
  end

  context 'when a query definition is provided' do
    let(:body) do
      { query: { match: {} } }
    end

    it 'passes the query definition' do
      expect(client_double.explain(index: 'foo', type: 'bar', id: '1', body: { query: { match: {} } })).to eq({})
    end
  end

  context 'when the request needs to be URL-escaped' do
    let(:url) do
      'foo%5Ebar/bar%2Fbam/1/_explain'
    end

    it 'URL-escapes the parts' do
      expect(client_double.explain(index: 'foo^bar', type: 'bar/bam', id: '1', body: { })).to eq({})
    end
  end
end
