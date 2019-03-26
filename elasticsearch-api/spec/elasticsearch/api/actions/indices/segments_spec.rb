require 'spec_helper'

describe 'client.cluster#segments' do

  let(:expected_args) do
    [
        'GET',
        url,
        params,
        body,
        nil
    ]
  end

  let(:url) do
    '_segments'
  end

  let(:body) do
    nil
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.indices.segments).to eq({})
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_segments'
    end

    it 'performs the request' do
      expect(client_double.indices.segments(index: 'foo')).to eq({})
    end
  end

  context 'when multiple indicies are specified as a list' do

    let(:url) do
      'foo,bar/_segments'
    end

    it 'performs the request' do
      expect(client_double.indices.segments(index: ['foo', 'bar'])).to eq({})
    end
  end

  context 'when multiple indicies are specified as a string' do

    let(:url) do
      'foo,bar/_segments'
    end

    it 'performs the request' do
      expect(client_double.indices.segments(index: 'foo,bar')).to eq({})
    end
  end

  context 'when the path needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_segments'
    end

    it 'performs the request' do
      expect(client_double.indices.segments(index: 'foo^bar')).to eq({})
    end
  end
end
