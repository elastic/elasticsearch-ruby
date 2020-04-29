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

describe 'client.indices#exists_type' do

  let(:expected_args) do
    [
        'HEAD',
        url,
        params,
        nil,
        {}
    ]
  end

  let(:params) do
    {}
  end

  let(:url) do
    'foo/_mapping/bar'
  end

  it 'performs the request' do
    expect(client_double.indices.exists_type(index: 'foo', type: 'bar')).to eq(true)
  end

  it 'aliased to a predicate method' do
    expect(client_double.indices.exists_type?(index: 'foo', type: 'bar')).to eq(true)
  end

  context 'when multiple indices are specified' do

    let(:url) do
      'foo,bar/_mapping/bam'
    end

    it 'performs the request' do
      expect(client_double.indices.exists_type(index: ['foo','bar'], type: 'bam')).to eq(true)
    end
  end

  context 'when the path needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_mapping/bar%2Fbam'
    end

    it 'performs the request' do
      expect(client_double.indices.exists_type(index: 'foo^bar', type: 'bar/bam')).to eq(true)
    end
  end

  context 'when 404 response is received' do

    let(:response_double) do
      double('response', status: 404, body: {}, headers: {})
    end

    it 'returns false' do
      expect(client_double.indices.exists_type(index: 'foo', type: 'bar')).to eq(false)
    end
  end

  context 'when a \'not found\' exception is raised' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new.tap do |_client|
        expect(_client).to receive(:perform_request).with(*expected_args).and_raise(StandardError.new('404 Not Found'))
      end
    end

    it 'returns false' do
      expect(client.indices.exists_type(index: 'foo', type: 'bar')).to eq(false)
    end
  end

  context 'when a generic exception is raised' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new.tap do |_client|
        expect(_client).to receive(:perform_request).with(*expected_args).and_raise(StandardError.new)
      end
    end

    it 'raises the exception' do
      expect {
        client.indices.exists_type(index: 'foo', type: 'bar')
      }.to raise_exception(StandardError)
    end
  end
end
