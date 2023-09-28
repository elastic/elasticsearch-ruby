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

describe 'client#create_document' do

  let(:expected_args) do
    [
        'PUT',
        'foo/_doc/123',
        { op_type: 'create' },
        { foo: 'bar' },
        {},
        { defined_params: { id: '123', index: 'foo' }, endpoint: 'index' }
    ]
  end

  it 'performs the request' do
    expect(client_double.create(index: 'foo', id: '123', body: { foo: 'bar'})).to be_a Elasticsearch::API::Response
  end

  context 'when the request needs to be URL-escaped' do

    let(:expected_args) do
      [
          'PUT',
          'foo/_doc/123',
          { op_type: 'create' },
          {},
          {}
      ]
    end

    let(:expected_args) do
      [
        'PUT',
        'foo/_doc/123',
        { op_type: 'create' },
        {},
        {},
        { defined_params: { id: '123', index: 'foo' }, endpoint: 'index' }
      ]
    end

    it 'performs the request' do
      expect(client_double.create(index: 'foo', id: '123', body: {})).to be_a Elasticsearch::API::Response
    end
  end

  context 'when an id is provided as an integer' do

    let(:expected_args) do
      [
          'PUT',
          'foo/_doc/1',
          { op_type: 'create' },
          { foo: 'bar' },
          {}
      ]
    end

    let(:expected_args) do
      [
        'PUT',
        'foo/_doc/1',
        { op_type: 'create' },
        { foo: 'bar' },
        {},
        { defined_params: { id: 1, index: 'foo' }, endpoint: 'index' }
      ]
    end

    it 'updates the arguments with the `op_type`' do
      expect(client_double.create(index: 'foo', id: 1, body: { foo: 'bar' })).to be_a Elasticsearch::API::Response
    end
  end

  context 'when an id is not provided' do

    let(:expected_args) do
      [
          'POST',
          'foo/_doc',
          { },
          { foo: 'bar' },
          {}
      ]
    end

    let(:expected_args) do
      [
        'POST',
        'foo/_doc',
        { },
        { foo: 'bar' },
        {},
        { defined_params: { index: 'foo' }, endpoint: 'index' }
      ]
    end

    it 'updates the arguments with the `op_type`' do
      expect(client_double.create(index: 'foo', body: { foo: 'bar' })).to be_a Elasticsearch::API::Response
    end
  end
end
