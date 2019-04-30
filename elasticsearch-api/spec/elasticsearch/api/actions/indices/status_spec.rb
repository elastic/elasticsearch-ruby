require 'spec_helper'

describe 'client.cluster#status' do

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
    '_status'
  end

  let(:body) do
    nil
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.indices.status).to eq({})
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_status'
    end

    it 'performs the request' do
      expect(client_double.indices.status(index: 'foo')).to eq({})
    end
  end

  context 'when multiple indicies are specified as a list' do

    let(:url) do
      'foo,bar/_status'
    end

    it 'performs the request' do
      expect(client_double.indices.status(index: ['foo', 'bar'])).to eq({})
    end
  end

  context 'when multiple indicies are specified as a string' do


    let(:url) do
      'foo,bar/_status'
    end

    it 'performs the request' do
      expect(client_double.indices.status(index: 'foo,bar')).to eq({})
    end
  end

  context 'when parameters are specified' do

    let(:params) do
      { recovery: true }
    end

    let(:url) do
      'foo/_status'
    end

    it 'performs the request' do
      expect(client_double.indices.status(index: 'foo', recovery: true)).to eq({})
    end
  end

  context 'when a \'not found\' exception is raised' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new.tap do |_client|
        expect(_client).to receive(:perform_request).and_raise(NotFound)
      end
    end

    it 'does not raise the exception' do
      expect(client.indices.status(index: 'foo', ignore: 404)).to eq(false)
    end
  end
end
