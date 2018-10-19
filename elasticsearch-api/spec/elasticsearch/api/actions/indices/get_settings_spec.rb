require 'spec_helper'

describe 'client.cluster#get_settings' do

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
    '_settings'
  end

  it 'performs the request' do
    expect(client_double.indices.get_settings).to eq({})
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_settings'
    end

    it 'performs the request' do
      expect(client_double.indices.get_settings(index: 'foo')).to eq({})
    end
  end

  context 'when a name is specified' do

    let(:url) do
      'foo/_settings/foo.bar'
    end

    it 'performs the request' do
      expect(client_double.indices.get_settings(index: 'foo', name: 'foo.bar')).to eq({})
    end
  end

  context 'when the path must be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_settings'
    end

    it 'performs the request' do
      expect(client_double.indices.get_settings(index: 'foo^bar')).to eq({})
    end
  end
end
