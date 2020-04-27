# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.indices#optimize' do

  let(:expected_args) do
    [
        'POST',
        url,
        params,
        nil,
        nil
    ]
  end

  let(:params) do
    {}
  end

  let(:url) do
    '_optimize'
  end

  it 'performs the request' do
    expect(client_double.indices.optimize).to eq({})
  end

  context 'when multiple indices are specified' do

    let(:url) do
      'foo,bar/_optimize'
    end

    it 'performs the request' do
      expect(client_double.indices.optimize(index: ['foo', 'bar'])).to eq({})
    end
  end

  context 'when parameters are specified' do

    let(:params) do
      { max_num_segments: 1 }
    end

    let(:url) do
      'foo/_optimize'
    end

    it 'performs the request' do
      expect(client_double.indices.optimize(index: 'foo', max_num_segments: 1)).to eq({})
    end
  end

  context 'when the path must be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_optimize'
    end

    it 'performs the request' do
      expect(client_double.indices.optimize(index: 'foo^bar')).to eq({})
    end
  end
end
