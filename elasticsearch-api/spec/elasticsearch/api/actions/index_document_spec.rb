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

describe 'client#index' do

  let(:expected_args) do
    [
        request_type,
        url,
        params,
        body,
        {},
        { defined_params: { index: 'foo' }, endpoint: 'index' }
    ]
  end

  let(:request_type) do
    'POST'
  end

  let(:params) do
    { }
  end

  let(:url) do
    'foo/_doc'
  end

  let(:body) do
    { foo: 'bar' }
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :index argument' do
    expect {
      client.index()
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.index(index: 'foo', body: body)).to be_a Elasticsearch::API::Response
  end

  context 'when a specific id is provided' do
    let(:request_type) do
      'PUT'
    end

    let(:url) do
      'foo/_doc/1'
    end

    let(:expected_args) do
      [
        request_type,
        url,
        params,
        body,
        {},
        { defined_params: { id: '1', index: 'foo' }, endpoint: 'index' }
      ]
    end

    it 'performs the request' do
      expect(client_double.index(index: 'foo', id: '1', body: body)).to be_a Elasticsearch::API::Response
    end
  end

  context 'when URL parameters are provided' do
    let(:request_type) do
      'POST'
    end

    let(:url) do
      'foo/_doc'
    end

    let(:params) do
      { op_type: 'create' }
    end

    it 'passes the URL params' do
      expect(client_double.index(index: 'foo', op_type: 'create', body: body)).to be_a Elasticsearch::API::Response
    end

    context 'when a specific id is provided' do
      let(:request_type) do
        'PUT'
      end

      let(:url) do
        'foo/_doc/1'
      end

      let(:params) do
        { op_type: 'create' }
      end

      let(:expected_args) do
        [
          request_type,
          url,
          params,
          body,
          {},
          { defined_params: { id: '1', index: 'foo' }, endpoint: 'index' }
        ]
      end

      it 'passes the URL params' do
        expect(client_double.index(index: 'foo', id: '1', op_type: 'create', body: body)).to be_a Elasticsearch::API::Response
      end
    end
  end

  context 'when an invalid URL parameter is provided' do
    it 'raises and ArgumentError' do
      expect {
        client.index(index: 'foo', id: '1', qwerty: 'yuiop')
      }.to raise_exception(ArgumentError)
    end
  end
end
