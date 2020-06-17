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

describe 'client.cluster#validate_query' do
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

  let(:url) do
    '_validate/query'
  end

  let(:body) do
    nil
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.indices.validate_query).to eq({})
  end

  context 'when an index is specified' do
    let(:url) do
      'foo/_validate/query'
    end

    it 'performs the request' do
      expect(client_double.indices.validate_query(index: 'foo')).to eq({})
    end
  end

  context 'when a type and index are specified' do
    let(:url) do
      'foo/bar/_validate/query'
    end

    it 'performs the request' do
      expect(client_double.indices.validate_query(index: 'foo', type: 'bar')).to eq({})
    end
  end

  context 'when multiple indicies are specified as a list' do
    let(:url) do
      'foo,bar/_validate/query'
    end

    it 'performs the request' do
      expect(client_double.indices.validate_query(index: ['foo', 'bar'])).to eq({})
    end
  end

  context 'when multiple indicies are specified as a string' do
    let(:url) do
      'foo,bar/_validate/query'
    end

    it 'performs the request' do
      expect(client_double.indices.validate_query(index: 'foo,bar')).to eq({})
    end
  end

  context 'when parameters are specified' do
    let(:params) do
      { explain: true, q: 'foo' }
    end

    let(:url) do
      '_validate/query'
    end

    it 'performs the request' do
      expect(client_double.indices.validate_query(explain: true, q: 'foo')).to eq({})
    end
  end

  context 'when a body is specified' do
    let(:body) do
      { filtered: {} }
    end
    let(:method) { 'POST' }

    it 'performs the request' do
      expect(client_double.indices.validate_query(body: { filtered: {} })).to eq({})
    end
  end

  context 'when the path needs to be URL-escaped' do
    let(:url) do
      'foo%5Ebar/_validate/query'
    end

    it 'performs the request' do
      expect(client_double.indices.validate_query(index: 'foo^bar')).to eq({})
    end
  end
end
