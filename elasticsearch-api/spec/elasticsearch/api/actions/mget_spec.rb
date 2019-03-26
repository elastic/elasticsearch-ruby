require 'spec_helper'

describe 'client#mget' do

  let(:expected_args) do
    [
        'GET',
        url,
        params,
        body
    ]
  end

  let(:body) do
    { docs: [] }
  end

  let(:url) do
    '_mget'
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.mget(body: { :docs => [] })).to eq({})
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_mget'
    end

    it 'performs the request' do
      expect(client_double.mget(index: 'foo', body: { :docs => [] })).to eq({})
    end
  end

  context 'when a type is specified' do

    let(:url) do
      'foo/bar/_mget'
    end

    let(:body) do
      { ids: [ '1', '2' ]}
    end

    it 'performs the request' do
      expect(client_double.mget(index: 'foo', type: 'bar', body: { :ids => [ '1', '2'] })).to eq({})
    end
  end

  context 'when url parameters are provided' do

    let(:params) do
      { refresh: true }
    end

    let(:body) do
      {}
    end

    it 'performs the request' do
      expect(client_double.mget(body: {}, refresh: true)).to eq({})
    end
  end

  context 'when the request needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/bar%2Fbam/_mget'
    end

    let(:body) do
      { ids: [ '1', '2' ]}
    end

    it 'performs the request' do
      expect(client_double.mget(index: 'foo^bar', type: 'bar/bam', body: { :ids => [ '1', '2'] })).to eq({})
    end
  end
end
