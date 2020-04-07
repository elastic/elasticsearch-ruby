# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.cluster#get_field_mapping' do

  let(:expected_args) do
    [
        'GET',
        url,
        {},
        nil,
        {}
    ]
  end

  let(:url) do
    '_mapping/field/foo'
  end

  it 'performs the request' do
    expect(client_double.indices.get_field_mapping(field: 'foo')).to eq({})
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_mapping/field/bam'
    end

    it 'performs the request' do
      expect(client_double.indices.get_field_mapping(index: 'foo', field: 'bam')).to eq({})
    end
  end
end
