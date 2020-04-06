# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#termvectors' do

  let(:expected_args) do
    [
        'GET',
        url,
        params,
        body
    ]
  end

  let(:url) do
    'foo/_termvectors/123'
  end

  let(:params) do
    {}
  end

  let(:body) do
    {}
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :index argument' do
    expect {
      client.termvectors(id: '1')
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.termvectors(index: 'foo', id: '123', body: {})).to eq({})
  end

  context 'when the older api name \'termvector\' is used' do

    let(:url) do
      'foo/_termvectors/123'
    end

    it 'performs the request' do
      expect(client_double.termvector(index: 'foo', id: '123', body: {})).to eq({})
    end
  end
end
