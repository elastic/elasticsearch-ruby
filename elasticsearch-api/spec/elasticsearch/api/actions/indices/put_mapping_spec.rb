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

describe 'client.cluster#put_mapping' do
  let(:expected_args) do
    [
        'PUT',
        url,
        {},
        body,
        {},
        { defined_params: { index: 'foo' }, endpoint: 'indices.put_mapping' }
    ]
  end

  let(:url) do
    'foo/_mapping'
  end

  let(:body) do
    {}
  end

  it 'performs the request' do
    expect(client_double.indices.put_mapping(index: 'foo', body: {})).to be_a Elasticsearch::API::Response
  end

  context 'when there is no type specified' do
    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.put_mapping(type: 'foo')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when there is no body specified' do
    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.put_mapping(index: 'foo')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when a body is specified' do
    let(:body) do
      { filter: 'foo' }
    end

    it 'performs the request' do
      expect(client_double.indices.put_mapping(index: 'foo', body: { filter: 'foo' })).to be_a Elasticsearch::API::Response
    end
  end

  context 'when multiple indices are specified' do
    let(:url) do
      'foo,bar/_mapping'
    end

    let(:expected_args) do
      [
        'PUT',
        url,
        {},
        body,
        {},
        { defined_params: { index: ['foo','bar'] }, endpoint: 'indices.put_mapping' }
      ]
    end

    it 'performs the request' do
      expect(client_double.indices.put_mapping(index: ['foo','bar'], body: {})).to be_a Elasticsearch::API::Response
    end
  end

  context 'when the path needs to be URL-escaped' do
    let(:url) do
      'foo%5Ebar/_mapping'
    end

    let(:expected_args) do
      [
        'PUT',
        url,
        {},
        body,
        {},
        { defined_params: { index: 'foo^bar' }, endpoint: 'indices.put_mapping' }
      ]
    end

    it 'performs the request' do
      expect(client_double.indices.put_mapping(index: 'foo^bar', body: {})).to be_a Elasticsearch::API::Response
    end
  end
end
