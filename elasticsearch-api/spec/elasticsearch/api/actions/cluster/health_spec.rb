# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.cluster#health' do

  let(:expected_args) do
    [
        'GET',
        '_cluster/health',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cluster.health).to eq({})
  end

  context 'when a level is specified' do

    let(:expected_args) do
      [
          'GET',
          '_cluster/health',
          { level: 'indices' },
          nil,
          nil
      ]
    end

    it 'performs the request' do
      expect(client_double.cluster.health(level: 'indices')).to eq({})
    end
  end

  context 'when an index is specified' do

    let(:expected_args) do
      [
          'GET',
          '_cluster/health/foo',
          {},
          nil,
          nil
      ]
    end

    it 'performs the request' do
      expect(client_double.cluster.health(index: 'foo')).to eq({})
    end
  end
end
