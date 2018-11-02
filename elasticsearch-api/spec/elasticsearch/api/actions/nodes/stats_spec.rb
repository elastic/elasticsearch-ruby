require 'spec_helper'

describe 'client.nodes#stats' do

  let(:expected_args) do
    [
        'GET',
        url,
        params,
        nil,
        nil
    ]
  end

  let(:url) do
    '_nodes/stats'
  end

  it 'performs the request' do
    expect(client_double.nodes.stats).to eq({})
  end

  let(:params) do
    {}
  end

  context 'when the node id is specified' do

    let(:url) do
      '_nodes/foo/stats'
    end

    it 'performs the request' do
      expect(client_double.nodes.stats(node_id: 'foo')).to eq({})
    end
  end

  context 'when metrics are specified' do

    let(:url) do
      '_nodes/stats/http,fs'
    end

    it 'performs the request' do
      expect(client_double.nodes.stats(metric: [:http, :fs])).to eq({})
    end
  end

  context 'when index metric is specified' do

    let(:url) do
      '_nodes/stats/indices/filter_cache'
    end

    it 'performs the request' do
      expect(client_double.nodes.stats(metric: :indices, index_metric: :filter_cache)).to eq({})
    end
  end
end
