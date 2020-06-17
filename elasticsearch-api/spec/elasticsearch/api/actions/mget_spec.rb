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

describe 'client#mget' do
  let(:expected_args) do
    [
      'POST',
      url,
      params,
      body,
      {}
    ]
  end

  let(:body) do
    { docs: [] }
  end

  let(:url) do
    '_mget'
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.mget(body: { :docs => [] })).to eq({})
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_mget'
    end

    it 'performs the request' do
      expect(client_double.mget(index: 'foo', body: { :docs => [] })).to eq({})
    end
  end

  context 'when a type is specified' do

    let(:url) do
      'foo/bar/_mget'
    end

    let(:body) do
      { ids: [ '1', '2' ]}
    end

    it 'performs the request' do
      expect(client_double.mget(index: 'foo', type: 'bar', body: { :ids => [ '1', '2'] })).to eq({})
    end
  end

  context 'when url parameters are provided' do

    let(:params) do
      { refresh: true }
    end

    let(:body) do
      {}
    end

    it 'performs the request' do
      expect(client_double.mget(body: {}, refresh: true)).to eq({})
    end
  end

  context 'when the request needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/bar%2Fbam/_mget'
    end

    let(:body) do
      { ids: [ '1', '2' ]}
    end

    it 'performs the request' do
      expect(client_double.mget(index: 'foo^bar', type: 'bar/bam', body: { :ids => [ '1', '2'] })).to eq({})
    end
  end
end
