require 'spec_helper'

describe 'client.nodes#shutdown' do

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
    '_cluster/nodes/_shutdown'
  end

  it 'performs the request' do
    expect(client_double.nodes.shutdown).to eq({})
  end

  let(:params) do
    {}
  end

  context 'when the node id is specified' do

    let(:url) do
      '_cluster/nodes/foo/_shutdown'
    end

    it 'performs the request' do
      expect(client_double.nodes.shutdown(node_id: 'foo')).to eq({})
    end
  end

  context 'when multiple node ids are specified as a list' do

    let(:url) do
      '_cluster/nodes/A,B,C/_shutdown'
    end

    it 'performs the request' do
      expect(client_double.nodes.shutdown(node_id: ['A', 'B', 'C'])).to eq({})
    end
  end

  context 'when multiple node ids are specified as a String' do

    let(:url) do
      '_cluster/nodes/A,B,C/_shutdown'
    end

    it 'performs the request' do
      expect(client_double.nodes.shutdown(node_id: 'A,B,C')).to eq({})
    end
  end
end
