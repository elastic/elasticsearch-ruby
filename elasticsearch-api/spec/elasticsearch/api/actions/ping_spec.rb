require 'spec_helper'

describe 'client#ping' do

  let(:expected_args) do
    [
        'HEAD',
        '',
        { },
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.ping).to eq(true)
  end

  context 'when the response is a 404' do

    let(:response_double) do
      double('response', status: 404, body: {}, headers: {})
    end

    it 'returns false' do
      expect(client_double.ping).to eq(false)
    end
  end

  context 'when a 404 \'not found\' exception is raised' do

    before do
      allow(client).to receive(:perform_request).and_raise(StandardError.new('404 NotFound'))
    end

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'returns false' do
      expect(client.ping).to eq(false)
    end
  end

  context 'when \'connection failed\' exception is raised' do

    before do
      allow(client).to receive(:perform_request).and_raise(StandardError.new('ConnectionFailed'))
    end

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'returns false' do
      expect(client.ping).to eq(false)
    end
  end
end
