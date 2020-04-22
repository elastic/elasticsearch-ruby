# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#reload_secure_settings' do

  let(:expected_args) do
    [
        'POST',
        url,
        params,
        body,
        {}
    ]
  end

  let(:params) { {} }
  let(:url) { '_nodes/reload_secure_settings' }
  let(:body) { nil }

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
    let(:body){ { foo: 'bar' } }

    let(:url) do
      '_nodes/foo,bar/reload_secure_settings'
    end

    it 'performs the request' do
      expect(client_double.nodes.reload_secure_settings(node_id: 'foo,bar', body: { foo: 'bar' })).to eq({})
    end
  end

  context 'when more than one node id is specified as a list' do
    let(:body){ { foo: 'bar' } }
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
