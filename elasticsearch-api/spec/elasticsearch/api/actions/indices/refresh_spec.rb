require 'spec_helper'

describe 'client.cluster#refresh' do

  let(:expected_args) do
    [
        'POST',
        url,
        params,
        body,
        nil
    ]
  end

  let(:url) do
    '_refresh'
  end

  let(:body) do
    nil
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.indices.refresh).to eq({})
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_refresh'
    end

    it 'performs the request' do
      expect(client_double.indices.refresh(index: 'foo')).to eq({})
    end
  end

  context 'when multiple indicies are specified as a list' do

    let(:url) do
      'foo,bar/_refresh'
    end

    it 'performs the request' do
      expect(client_double.indices.refresh(index: ['foo', 'bar'])).to eq({})
    end
  end

  context 'when multiple indicies are specified as a string' do

    let(:url) do
      'foo,bar/_refresh'
    end

    it 'performs the request' do
      expect(client_double.indices.refresh(index: 'foo,bar')).to eq({})
    end
  end

  context 'when the path needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_refresh'
    end

    it 'performs the request' do
      expect(client_double.indices.refresh(index: 'foo^bar')).to eq({})
    end
  end
end
