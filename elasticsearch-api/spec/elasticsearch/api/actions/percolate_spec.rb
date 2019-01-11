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

describe 'client#percolate' do

  let(:expected_args) do
    [
        'GET',
        url,
        { },
        body
    ]
  end

  let(:body) do
    { doc: { foo: 'bar' }}
  end

  let(:url) do
    'foo/bar/_percolate'
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :index argument' do
    expect {
      client.percolate(type: 'bar', body: {})
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.percolate(index: 'foo', type: 'bar', body: { doc: { foo: 'bar' } })).to eq({})
  end

  context 'when the request needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/bar%2Fbam/_percolate'
    end

    it 'URL-escapes the parts' do
      expect(client_double.percolate(index: 'foo^bar', type: 'bar/bam', body: { doc: { foo: 'bar' } })).to eq({})
    end
  end

  context 'when the document id needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/bar%2Fbam/some%2Fid/_percolate'
    end

    let(:body) do
      nil
    end

    it 'URL-escapes the id' do
      expect(client_double.percolate(index: 'foo^bar', type: 'bar/bam', id: 'some/id')).to eq({})
    end
  end
end
