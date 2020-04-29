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

describe 'client#get_source' do

  let(:expected_args) do
    [
        'GET',
        url,
        params,
        nil,
        {}
    ]
  end

  let(:params) do
    { }
  end

  let(:url) do
    'foo/bar/1/_source'
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :index argument' do
    expect {
      client.get_source(type: 'bar', id: '1')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :id argument' do
    expect {
      client.get_source(index: 'foo', type: 'bar')
    }.to raise_exception(ArgumentError)
  end

  context 'when the type parameter is not provided' do

    let(:url) do
      'foo/_source/1'
    end

    it 'performs the request' do
      expect(client_double.get_source(index: 'foo', id: '1')).to eq({})
    end
  end

  context 'when URL parameters are provided' do

    let(:params) do
      { routing: 'abc123' }
    end

    it 'Passes the URL params' do
      expect(client_double.get_source(index: 'foo', type: 'bar', id: '1', routing: 'abc123')).to eq({})
    end
  end

  context 'when the request needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/bar%2Fbam/1/_source'
    end

    it 'URL-escapes the parts' do
      expect(client_double.get_source(index: 'foo^bar', type: 'bar/bam', id: '1')).to eq({})
    end
  end

  context 'when the request raises a NotFound error' do

    before do
      expect(client).to receive(:perform_request).and_raise(NotFound)
    end

    it 'raises the error' do
      expect {
        client.get_source(index: 'foo', id: '1')
      }.to raise_exception(NotFound)
    end
  end
end
