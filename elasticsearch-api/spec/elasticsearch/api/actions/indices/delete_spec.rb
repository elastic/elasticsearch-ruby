require 'spec_helper'

describe 'client.indices#delete' do

  let(:expected_args) do
    [
        'DELETE',
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
    'foo'
  end

  it 'performs the request' do
    expect(client_double.indices.delete(index: 'foo')).to eq({})
  end

  context 'when more than one index is specified' do

    let(:url) do
      'foo,bar'
    end

    it 'performs the request' do
      expect(client_double.indices.delete(index: ['foo', 'bar'])).to eq({})
    end
  end

  context 'when params are specified' do

    let(:params) do
      { timeout: '1s' }
    end

    it 'performs the request' do
      expect(client_double.indices.delete(index: 'foo', timeout: '1s')).to eq({})
    end
  end

  context 'when the path must be URL-escaped' do

    let(:url) do
      'foo%5Ebar'
    end

    it 'performs the request' do
      expect(client_double.indices.delete(index: 'foo^bar')).to eq({})
    end
  end

  context 'when a NotFound exception is raised by the request' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    before do
      expect(client).to receive(:perform_request).and_raise(NotFound)
    end

    it 'raises the exception' do
      expect {
        client.indices.delete(index: 'foo')
      }.to raise_exception(NotFound)
    end
  end

  context 'when the ignore parameter is specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    before do
      expect(client).to receive(:perform_request).and_raise(NotFound)
    end

    it 'ignores the code' do
      expect(client.indices.delete(index: 'foo', ignore: 404)).to eq(false)
    end
  end
end
