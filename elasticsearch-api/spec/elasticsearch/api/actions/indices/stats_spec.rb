# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.cluster#stats' do

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
    '_stats'
  end

  let(:body) do
    nil
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.indices.stats).to eq({})
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_stats'
    end

    it 'performs the request' do
      expect(client_double.indices.stats(index: 'foo')).to eq({})
    end
  end

  context 'when multiple indicies are specified as a list' do

    let(:url) do
      'foo,bar/_stats'
    end

    it 'performs the request' do
      expect(client_double.indices.stats(index: ['foo', 'bar'])).to eq({})
    end
  end

  context 'when multiple indicies are specified as a string' do

    let(:url) do
      'foo,bar/_stats'
    end

    it 'performs the request' do
      expect(client_double.indices.stats(index: 'foo,bar')).to eq({})
    end
  end

  context 'when parameters are specified' do
    let(:params) do
      { expand_wildcards: true }
    end

    let(:url) do
      'foo/_stats'
    end

    it 'performs the request' do
      expect(client_double.indices.stats(index: 'foo', expand_wildcards: true)).to eq({})
    end
  end

  context 'when the fields parameter is specified as a list' do

    let(:params) do
      { fields: 'foo,bar' }
    end

    let(:url) do
      'foo/_stats/fielddata'
    end

    it 'performs the request' do
      expect(client_double.indices.stats(index: 'foo', fielddata: true, fields: [ 'foo', 'bar'])).to eq({})
    end
  end

  context 'when the groups parameter is specified as a list' do

    let(:params) do
      { groups: 'groupA,groupB' }
    end

    let(:url) do
      '_stats/search'
    end

    it 'performs the request' do
      expect(client_double.indices.stats(search: true, groups: [ 'groupA', 'groupB'])).to eq({})
    end
  end
end
