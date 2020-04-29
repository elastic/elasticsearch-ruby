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

describe 'client#update' do

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
    { doc: { } }
  end

  let(:url) do
    'foo/bar/1/_update'
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  let(:params) do
    {}
  end

  it 'requires the :index argument' do
    expect {
      client.update(type: 'bar', id: '1')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :id argument' do
    expect {
      client.update(index: 'foo', type: 'bar')
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.update(index: 'foo', type: 'bar', id: '1', body: { doc: {} })).to eq({})
  end

  context 'when URL parameters are provided' do

    let(:url) do
      'foo/bar/1/_update'
    end

    let(:body) do
      {}
    end

    it 'performs the request' do
      expect(client_double.update(index: 'foo', type: 'bar', id: '1', body: {}))
    end
  end

  context 'when invalid parameters are specified' do

    it 'raises an ArgumentError' do
      expect {
        client.update(index: 'foo', type: 'bar', id: '1', body: { doc: {} }, qwertypoiuy: 'asdflkjhg')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when the request needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/bar%2Fbam/1/_update'
    end

    let(:body) do
      {}
    end

    it 'escapes the parts' do
      expect(client_double.update(index: 'foo^bar', type: 'bar/bam', id: '1', body: {}))
    end
  end

  context 'when a NotFound exception is raised' do

    before do
      allow(client).to receive(:perform_request).and_raise(NotFound)
    end

    it 'raises it to the user' do
      expect {
        client.update(index: 'foo', type: 'bar', id: 'XXX', body: {})
      }.to raise_exception(NotFound)
    end

    context 'when the :ignore parameter is specified' do

      it 'does not raise the error to the user' do
        expect(client.update(index: 'foo', type: 'bar', id: 'XXX', body: {}, ignore: 404)).to eq(false)
      end
    end
  end
end
