require 'spec_helper'

describe 'client.indices#clear_cache' do

  let(:expected_args) do
    [
        'POST',
        url,
        params,
        nil,
        nil
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

    let(:params) do
      { index: 'foo' }
    end

    it 'performs the request' do
      expect(client_double.indices.clear_cache(index: 'foo')).to eq({})
    end
  end

  context 'when params are specified' do

    let(:params) do
      { field_data: true }
    end

    it 'performs the request' do
      expect(client_double.indices.clear_cache(field_data: true)).to eq({})
    end
  end

  context 'when the path must be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_cache/clear'
    end

    let(:params) do
      { index: 'foo^bar' }
    end

    it 'performs the request' do
      expect(client_double.indices.clear_cache(index: 'foo^bar')).to eq({})
    end
  end
end
