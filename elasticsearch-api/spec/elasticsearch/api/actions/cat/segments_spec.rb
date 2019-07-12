# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.cat#segments' do

  let(:expected_args) do
    [
        'GET',
        '_cat/segments',
        params,
        nil,
        nil
    ]
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.cat.segments).to eq({})
  end

  context 'when index is specified' do


    let(:params) do
      { index: 'foo' }
    end

    it 'performs the request' do
      expect(client_double.cat.segments(index: 'foo')).to eq({})
    end
  end
end
