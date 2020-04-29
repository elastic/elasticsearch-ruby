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

describe 'client#exists' do

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
    'foo/bar/1'
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :index argument' do
    expect {
      client.exists(type: 'bar', id: '1')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :id argument' do
    expect {
      client.exists(index: 'foo', type: 'bar')
    }.to raise_exception(ArgumentError)
  end

  context 'when the type parameter is not provided' do

    let(:url) do
      'foo/_doc/1'
    end

    it 'performs the request' do
      expect(client_double.exists(index: 'foo', id: '1')).to eq(true)
    end
  end

  it 'is aliased to a predicated method' do
    expect(client_double.exists?(index: 'foo', type: 'bar', id: '1')).to eq(true)
  end

  context 'when URL parameters are provided' do

    let(:params) do
      { routing: 'abc123' }
    end

    it 'passes the parameters' do
      expect(client_double.exists(index: 'foo', type: 'bar', id: '1', routing: 'abc123')).to eq(true)
    end
  end

  context 'when the request needs to be URL-escaped' do

    let(:url) do
      'foo/bar%2Fbam/1'
    end

    it 'URL-escapes the characters' do
      expect(client_double.exists(index: 'foo', type: 'bar/bam', id: '1')).to eq(true)
    end
  end

  context 'when the response is 404' do

    before do
      expect(response_double).to receive(:status).and_return(404)
    end

    it 'returns false' do
      expect(client_double.exists(index: 'foo', type: 'bar', id: '1')).to eq(false)
    end
  end

  context 'when the response is 404 NotFound' do

    before do
      expect(response_double).to receive(:status).and_raise(StandardError.new('404 NotFound'))
    end

    it 'returns false' do
      expect(client_double.exists(index: 'foo', type: 'bar', id: '1')).to eq(false)
    end
  end

  context 'when there are other errors' do

    before do
      expect(response_double).to receive(:status).and_raise(StandardError)
    end

    it 'raises the error' do
      expect {
        client_double.exists(index: 'foo', type: 'bar', id: '1')
      }.to raise_exception(StandardError)
    end
  end
end
