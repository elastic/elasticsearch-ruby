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

describe 'client.cluster#put_settings' do

  let(:expected_args) do
    [
        'PUT',
        url,
        params,
        body,
        {}
    ]
  end

  let(:url) do
    '_settings'
  end

  let(:body) do
    {}
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.indices.put_settings(body: {})).to eq({})
  end

  context 'when there is no body specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.put_settings
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when parameters are specified' do

    let(:params) do
      { flat_settings: true }
    end

    let(:url) do
      'foo/_settings'
    end

    it 'performs the request' do
      expect(client_double.indices.put_settings(index: 'foo', flat_settings: true, body: {})).to eq({})
    end
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_settings'
    end

    it 'performs the request' do
      expect(client_double.indices.put_settings(index: 'foo', body: {})).to eq({})
    end
  end

  context 'when multiple indices are specified' do

    let(:url) do
      'foo,bar/_settings'
    end

    it 'performs the request' do
      expect(client_double.indices.put_settings(index: ['foo','bar'], body: {})).to eq({})
    end
  end

  context 'when the path needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_settings'
    end

    it 'performs the request' do
      expect(client_double.indices.put_settings(index: 'foo^bar', body: {})).to eq({})
    end
  end
end
