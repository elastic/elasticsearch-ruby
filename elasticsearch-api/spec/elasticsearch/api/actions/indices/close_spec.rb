require 'spec_helper'

describe 'client.indices#close' do

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

  context 'when there is no index specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.close
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_close'
    end

    it 'performs the request' do
      expect(client_double.indices.close(index: 'foo')).to eq({})
    end
  end

  context 'when params are specified' do

    let(:params) do
      { timeout: '1s' }
    end

    let(:url) do
      'foo/_close'
    end

    it 'performs the request' do
      expect(client_double.indices.close(index: 'foo', timeout: '1s')).to eq({})
    end
  end

  context 'when the path must be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_close'
    end

    it 'performs the request' do
      expect(client_double.indices.close(index: 'foo^bar')).to eq({})
    end
  end
end
