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

describe 'client.cluster#status' do

  let(:expected_args) do
    [
        'GET',
        url,
        params,
        body,
        nil
    ]
  end

  let(:url) do
    '_status'
  end

  let(:body) do
    nil
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.indices.status).to eq({})
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_status'
    end

    it 'performs the request' do
      expect(client_double.indices.status(index: 'foo')).to eq({})
    end
  end

  context 'when multiple indicies are specified as a list' do

    let(:url) do
      'foo,bar/_status'
    end

    it 'performs the request' do
      expect(client_double.indices.status(index: ['foo', 'bar'])).to eq({})
    end
  end

  context 'when multiple indicies are specified as a string' do


    let(:url) do
      'foo,bar/_status'
    end

    it 'performs the request' do
      expect(client_double.indices.status(index: 'foo,bar')).to eq({})
    end
  end

  context 'when parameters are specified' do

    let(:params) do
      { recovery: true }
    end

    let(:url) do
      'foo/_status'
    end

    it 'performs the request' do
      expect(client_double.indices.status(index: 'foo', recovery: true)).to eq({})
    end
  end

  context 'when a \'not found\' exception is raised' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new.tap do |_client|
        expect(_client).to receive(:perform_request).and_raise(NotFound)
      end
    end

    it 'does not raise the exception' do
      expect(client.indices.status(index: 'foo', ignore: 404)).to eq(false)
    end
  end
end
