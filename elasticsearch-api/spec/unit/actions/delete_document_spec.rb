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

describe 'client#delete' do

  let(:expected_args) do
    [
        'DELETE',
        'foo/_doc/1',
        params,
        nil,
        {},
        { defined_params: { id: '1', index: 'foo' }, endpoint: 'delete' }
    ]
  end

  let(:params) do
    {}
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :index argument' do
    expect {
      client.delete(id: '1')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :id argument' do
    expect {
      client.delete(index: 'foo')
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.delete(index: 'foo', id: '1')).to be_a Elasticsearch::API::Response
  end

  context 'when url params are provided' do
    let(:params) do
      { routing: 'abc123' }
    end

    it 'performs the request' do
      expect(client_double.delete(index: 'foo', id: '1', routing: 'abc123')).to be_a Elasticsearch::API::Response
    end
  end

  context 'when the url params need to be escaped' do
    let(:expected_args) do
      [
          'DELETE',
          'foo%5Ebar/_doc/1',
          params,
          nil,
          {},
          { defined_params: { id: 1, index: 'foo^bar' }, endpoint: 'delete' }
      ]
    end

    it 'escapes the url params' do
      expect(client_double.delete(index: 'foo^bar', id: 1)).to be_a Elasticsearch::API::Response
    end
  end

  context 'when the index is not found' do
    before do
      expect(client).to receive(:perform_request).and_raise(NotFound)
    end

    it 'raises the exception' do
      expect {
        client.delete(index: 'foo', id: 'XXX')
      }.to raise_exception(NotFound)
    end

    context 'when the :ignore option is provided' do
      it 'does not raise the NotFound exception' do
        expect(client.delete(index: 'foo', id: 1, ignore: 404)).to eq(false)
      end
    end
  end
end
