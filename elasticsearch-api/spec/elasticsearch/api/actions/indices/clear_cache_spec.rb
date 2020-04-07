# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information
#
require 'spec_helper'

describe 'client.indices#clear_cache' do

  let(:expected_args) do
    [
        'POST',
        url,
        params,
        nil,
        {}
    ]
  end

  let(:url) do
    '_cache/clear'
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.indices.clear_cache).to eq({})
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_cache/clear'
    end

    it 'performs the request' do
      expect(client_double.indices.clear_cache(index: 'foo')).to eq({})
    end
  end

  context 'when params are specified' do

    let(:params) do
      { fielddata: true }
    end

    it 'performs the request' do
      expect(client_double.indices.clear_cache(fielddata: true)).to eq({})
    end
  end

  context 'when the path must be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_cache/clear'
    end

    let(:params) do
      { }
    end

    it 'performs the request' do
      expect(client_double.indices.clear_cache(index: 'foo^bar')).to eq({})
    end
  end
end
