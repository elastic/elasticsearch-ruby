require 'spec_helper'

describe 'client.cluster#snapshot_index' do

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
    '_gateway/snapshot'
  end

  let(:body) do
    nil
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.indices.snapshot_index).to eq({})
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_gateway/snapshot'
    end

    it 'performs the request' do
      expect(client_double.indices.snapshot_index(index: 'foo')).to eq({})
    end
  end

  context 'when multiple indicies are specified as a list' do

    let(:url) do
      'foo,bar/_gateway/snapshot'
    end

    it 'performs the request' do
      expect(client_double.indices.snapshot_index(index: ['foo', 'bar'])).to eq({})
    end
  end

  context 'when multiple indicies are specified as a string' do

    let(:url) do
      'foo,bar/_gateway/snapshot'
    end

    it 'performs the request' do
      expect(client_double.indices.snapshot_index(index: 'foo,bar')).to eq({})
    end
  end

  context 'when parameters are specified' do

    let(:params) do
      { ignore_indices: 'missing' }
    end

    let(:url) do
      'foo/_gateway/snapshot'
    end

    it 'performs the request' do
      expect(client_double.indices.snapshot_index(index: 'foo', ignore_indices: 'missing')).to eq({})
    end
  end

  context 'when the path needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_gateway/snapshot'
    end

    it 'performs the request' do
      expect(client_double.indices.snapshot_index(index: 'foo^bar')).to eq({})
    end
  end
end
