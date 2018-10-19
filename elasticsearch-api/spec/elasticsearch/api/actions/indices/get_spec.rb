require 'spec_helper'

describe 'client.indices#get' do

  let(:expected_args) do
    [
        'GET',
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
    'foo'
  end

  it 'performs the request' do
    expect(client_double.indices.get(index: 'foo')).to eq({})
  end

  context 'when parameters are specified' do

    let(:params) do
      { ignore_unavailable: 1 }
    end

    it 'performs the request' do
      expect(client_double.indices.get(index: 'foo', ignore_unavailable: 1)).to eq({})
    end
  end

  context 'when features are specified' do

    let(:url) do
      'foo/_settings'
    end

    it 'includes them in the URL' do
      expect(client_double.indices.get(index: 'foo', feature: '_settings')).to eq({})
    end
  end
end
