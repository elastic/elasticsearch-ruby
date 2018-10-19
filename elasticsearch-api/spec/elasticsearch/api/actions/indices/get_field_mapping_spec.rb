require 'spec_helper'

describe 'client.cluster#get_field_mapping' do

  let(:expected_args) do
    [
        'GET',
        url,
        {},
        nil,
        nil
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

  context 'when a type is specified' do

    let(:url) do
      'foo/_mapping/bar/field/bam'
    end

    it 'performs the request' do
      expect(client_double.indices.get_field_mapping(index: 'foo', type: 'bar', field: 'bam')).to eq({})
    end
  end
end
