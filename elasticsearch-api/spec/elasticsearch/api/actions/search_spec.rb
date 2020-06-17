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

describe 'client#search' do
  let(:expected_args) do
    [
      method,
      url,
      params,
      body,
      {}
    ]
  end
  let(:method) { 'GET' }

  let(:body) do
    nil
  end

  let(:params) do
    {}
  end

  let(:url) do
    '_all/foo/_search'
  end

  it 'has a default value for index' do
    expect(client_double.search(type: 'foo'))
  end

  context 'when a request definition is specified' do
    let(:body) do
      { query: { match: {} } }
    end
    let(:method) { 'POST' }

    let(:url) do
      '_search'
    end

    it 'performs the request' do
      expect(client_double.search(body: { query: { match: {} } }))
    end
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_search'
    end

    it 'performs the request' do
      expect(client_double.search(index: 'foo'))
    end
  end

  context 'when an index and type are specified' do

    let(:url) do
      'foo/bar/_search'
    end

    it 'performs the request' do
      expect(client_double.search(index: 'foo', type: 'bar'))
    end
  end

  context 'when multiple indices are specified' do

    let(:url) do
      'foo,bar/_search'
    end

    it 'performs the request' do
      expect(client_double.search(index: ['foo', 'bar']))
    end
  end

  context 'when multiple indices and types are specified' do

    let(:url) do
      'foo,bar/lam,bam/_search'
    end

    it 'performs the request' do
      expect(client_double.search(index: ['foo', 'bar'], type: ['lam', 'bam']))
    end
  end

  context 'when there are URL params' do

    let(:url) do
      '_search'
    end

    let(:params) do
      { search_type: 'count' }
    end

    it 'performs the request' do
      expect(client_double.search(search_type: 'count'))
    end
  end

  context 'when there are invalid URL params' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an ArgumentError' do
      expect{
        client.search(search_type: 'count', qwertypoiuy: 'asdflkjhg')
      }.to raise_exception(ArgumentError)
    end
  end
end
