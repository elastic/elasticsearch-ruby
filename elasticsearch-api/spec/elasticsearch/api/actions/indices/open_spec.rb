require 'spec_helper'

describe 'client.indices#open' do

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
    'foo/_open'
  end

  it 'performs the request' do
    expect(client_double.indices.open(index: 'foo')).to eq({})
  end

  context 'when parameters are specified' do

    let(:params) do
      { timeout: '1s' }
    end

    it 'performs the request' do
      expect(client_double.indices.open(index: 'foo', timeout: '1s')).to eq({})
    end
  end

  context 'when the path must be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_open'
    end

    it 'performs the request' do
      expect(client_double.indices.open(index: 'foo^bar')).to eq({})
    end
  end
end
