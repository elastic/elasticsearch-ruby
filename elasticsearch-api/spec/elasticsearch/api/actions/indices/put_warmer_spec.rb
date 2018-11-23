# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require 'spec_helper'

describe 'client.cluster#put_warmer' do

  let(:expected_args) do
    [
        'PUT',
        url,
        params,
        body,
        nil
    ]
  end

  let(:url) do
    'foo/_warmer/bar'
  end

  let(:body) do
    { query: { match_all: {} } }
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.indices.put_warmer(index: 'foo', name: 'bar', body: { query: { match_all: {} } })).to eq({})
  end

  context 'when there is no name specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.put_warmer(body: {})
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when there is no body specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.put_warmer(name: 'foo')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when multiple indices are specified' do

    let(:url) do
      'foo,bar/_warmer/xul'
    end

    let(:body) do
      {}
    end

    it 'performs the request' do
      expect(client_double.indices.put_warmer(index: ['foo', 'bar'], name: 'xul', body: {})).to eq({})
    end
  end

  context 'when a type is specified' do

    let(:url) do
      'foo/bar/_warmer/xul'
    end

    let(:body) do
      {}
    end

    it 'performs the request' do
      expect(client_double.indices.put_warmer(index: 'foo', type: 'bar', name: 'xul', body: {})).to eq({})
    end
  end

  context 'when the path needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/bar%2Fbam/_warmer/qu+uz'
    end

    let(:body) do
      {}
    end

    it 'performs the request' do
      expect(client_double.indices.put_warmer(index: 'foo^bar', type: 'bar/bam', name: 'qu uz', body: {})).to eq({})
    end
  end
end
