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
      {},
      { defined_params: { id: '1', index: 'foo' }, endpoint: 'update' }
    ]
  end

  let(:body) do
    { doc: { } }
  end

  let(:url) do
    'foo/_update/1'
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  let(:params) do
    {}
  end

  it 'requires the :index argument' do
    expect {
      client.update(id: '1')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :id argument' do
    expect {
      client.update(index: 'foo')
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.update(index: 'foo', id: '1', body: { doc: {} })).to be_a Elasticsearch::API::Response
  end

  context 'when URL parameters are provided' do
    let(:url) do
      'foo/_update/1'
    end

    let(:body) do
      {}
    end

    it 'performs the request' do
      expect(client_double.update(index: 'foo', id: '1', body: {}))
    end
  end

  context 'when the request needs to be URL-escaped' do
    let(:url) do
      'foo%5Ebar/_update/1'
    end

    let(:body) do
      {}
    end

    let(:expected_args) do
      [
        'POST',
        url,
        params,
        body,
        {},
        { defined_params: { id: '1', index: 'foo^bar' }, endpoint: 'update' }
      ]
    end

    it 'escapes the parts' do
      expect(client_double.update(index: 'foo^bar', id: '1', body: {}))
    end
  end

  context 'when a NotFound exception is raised' do
    before do
      allow(client).to receive(:perform_request).and_raise(NotFound)
    end

    it 'raises it to the user' do
      expect {
        client.update(index: 'foo', id: 'XXX', body: {})
      }.to raise_exception(NotFound)
    end

    context 'when the :ignore parameter is specified' do
      it 'does not raise the error to the user' do
        expect(client.update(index: 'foo', id: 'XXX', body: {}, ignore: 404)).to eq(false)
      end
    end
  end
end
