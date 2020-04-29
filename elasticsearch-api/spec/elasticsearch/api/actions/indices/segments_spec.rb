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

describe 'client.cluster#segments' do

  let(:expected_args) do
    [
        'GET',
        url,
        params,
        body,
        {}
    ]
  end

  let(:url) do
    '_segments'
  end

  let(:body) do
    nil
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.indices.segments).to eq({})
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_segments'
    end

    it 'performs the request' do
      expect(client_double.indices.segments(index: 'foo')).to eq({})
    end
  end

  context 'when multiple indicies are specified as a list' do

    let(:url) do
      'foo,bar/_segments'
    end

    it 'performs the request' do
      expect(client_double.indices.segments(index: ['foo', 'bar'])).to eq({})
    end
  end

  context 'when multiple indicies are specified as a string' do

    let(:url) do
      'foo,bar/_segments'
    end

    it 'performs the request' do
      expect(client_double.indices.segments(index: 'foo,bar')).to eq({})
    end
  end

  context 'when the path needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_segments'
    end

    it 'performs the request' do
      expect(client_double.indices.segments(index: 'foo^bar')).to eq({})
    end
  end
end
