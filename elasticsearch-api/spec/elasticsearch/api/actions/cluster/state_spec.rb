# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.cluster#state' do

  let(:expected_args) do
    [
        'GET',
        '_cluster/state',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cluster.state).to eq({})
  end

  context 'when a metric is specified' do

    let(:expected_args) do
      [
          'GET',
          '_cluster/state/foo,bar',
          {},
          nil,
          nil
      ]
    end

    it 'performs the request' do
      expect(client_double.cluster.state(metric: ['foo', 'bar'])).to eq({})
    end
  end
end
