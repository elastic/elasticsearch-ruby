require 'spec_helper'

describe 'client.nodes#hot_threads' do

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
    '_nodes/hot_threads'
  end

  it 'performs the request' do
    expect(client_double.nodes.hot_threads).to eq({})
  end

  context 'when the node id is specified' do

    let(:url) do
      '_nodes/foo/hot_threads'
    end

    it 'performs the request' do
      expect(client_double.nodes.hot_threads(node_id: 'foo')).to eq({})
    end
  end

  context 'when the path must be URL-escaped' do

    let(:url) do
      '_nodes/foo%5Ebar/hot_threads'
    end

    it 'performs the request' do
      expect(client_double.nodes.hot_threads(node_id: 'foo^bar')).to eq({})
    end
  end
end
