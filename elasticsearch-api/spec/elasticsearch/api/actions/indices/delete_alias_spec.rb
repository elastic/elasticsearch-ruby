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

describe 'client.indices#delete_alias' do

  let(:expected_args) do
    [
        'DELETE',
        url,
        params,
        nil,
        {}
    ]
  end

  let(:params) do
    {}
  end

  context 'when there is no index specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.delete_alias(name: 'foo')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when there is no name specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.delete_alias(index: 'foo')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when an index and name are specified' do

    let(:url) do
      'foo/_aliases/bar'
    end

    it 'performs the request' do
      expect(client_double.indices.delete_alias(index: 'foo', name: 'bar')).to eq({})
    end
  end

  context 'when the path must be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_aliases/bar%2Fbam'
    end

    it 'performs the request' do
      expect(client_double.indices.delete_alias(index: 'foo^bar', name: 'bar/bam')).to eq({})
    end
  end
end
