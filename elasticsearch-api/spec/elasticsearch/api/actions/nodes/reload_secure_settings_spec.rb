require 'spec_helper'

describe 'client#reload_secure_settings' do

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
    '_nodes/reload_secure_settings'
  end

  it 'performs the request' do
    expect(client_double.nodes.reload_secure_settings()).to eq({})
  end

  context 'when a node id is specified' do

    let(:url) do
      '_nodes/foo/reload_secure_settings'
    end

    it 'performs the request' do
      expect(client_double.nodes.reload_secure_settings(node_id: 'foo')).to eq({})
    end
  end

  context 'when more than one node id is specified as a string' do

    let(:url) do
      '_nodes/foo,bar/reload_secure_settings'
    end

    it 'performs the request' do
      expect(client_double.nodes.reload_secure_settings(node_id: 'foo,bar', body: { foo: 'bar' })).to eq({})
    end
  end

  context 'when more than one node id is specified as a list' do

    let(:url) do
      '_nodes/foo,bar/reload_secure_settings'
    end

    it 'performs the request' do
      expect(client_double.nodes.reload_secure_settings(node_id: ['foo', 'bar'], body: { foo: 'bar' })).to eq({})
    end
  end

  context 'when a timeout param is specified' do

    let(:params) do
      { timeout: '30s'}
    end

    it 'performs the request' do
      expect(client_double.nodes.reload_secure_settings(timeout: '30s')).to eq({})
    end
  end
end
