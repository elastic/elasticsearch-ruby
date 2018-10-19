require 'spec_helper'

describe 'client.indices#flush_synced' do

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
    'foo/_flush/synced'
  end

  it 'performs the request' do
    expect(client_double.indices.flush_synced(index: 'foo')).to eq({})
  end

  context 'when a \'not found\' exception is raised' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new.tap do |_client|
        expect(_client).to receive(:perform_request).with(*expected_args).and_raise(NotFound)
      end
    end

    it 'raises the exception' do
      expect {
        client.indices.flush_synced(index: 'foo')
      }.to raise_exception(NotFound)
    end
  end

  context 'when a \'not found\' exception is raised' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new.tap do |_client|
        expect(_client).to receive(:perform_request).with(*expected_args).and_raise(NotFound)
      end
    end

    it 'raises the exception' do
      expect {
        client.indices.flush_synced(index: 'foo')
      }.to raise_exception(NotFound)
    end
  end

  context 'when the ignore parameter is specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new.tap do |_client|
        expect(_client).to receive(:perform_request).with(*expected_args).and_raise(StandardError.new('404 Not Found'))
      end
    end

    let(:params) do
      { ignore: 404 }
    end

    it 'does not raise the exception' do
      expect(client.indices.flush_synced(index: 'foo', ignore: 404)).to eq(false)
    end
  end
end
