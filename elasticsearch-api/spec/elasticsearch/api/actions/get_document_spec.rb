require 'spec_helper'

describe 'client#get' do

  let(:expected_args) do
    [
        'GET',
        url,
        params,
        nil
    ]
  end

  let(:params) do
    { }
  end

  let(:url) do
    'foo/bar/1'
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :index argument' do
    expect {
      client.get(type: 'bar', id: '1')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :id argument' do
    expect {
      client.get(index: 'foo', type: 'bar')
    }.to raise_exception(ArgumentError)
  end

  context 'when the type parameter is not provided' do

    let(:url) do
      'foo/_all/1'
    end

    it 'performs the request' do
      expect(client_double.get(index: 'foo', id: '1')).to eq({})
    end
  end

  context 'when URL parameters are provided' do

    let(:params) do
      { routing: 'abc123' }
    end

    it 'Passes the URL params' do
      expect(client_double.get(index: 'foo', type: 'bar', id: '1', routing: 'abc123')).to eq({})
    end
  end

  context 'when invalid URL parameters are provided' do

    it 'Passes the URL params' do
      expect {
        client.get(index: 'foo', type: 'bar', id: '1', qwert: 'abc123')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when the request needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/bar%2Fbam/1'
    end

    it 'URL-escapes the parts' do
      expect(client_double.get(index: 'foo^bar', type: 'bar/bam', id: '1')).to eq({})
    end
  end

  context 'when the request raises a NotFound error' do

    before do
      expect(client).to receive(:perform_request).and_raise(NotFound)
    end

    it 'raises an exception' do
      expect {
        client.get(index: 'foo', id: '1')
      }.to raise_exception(NotFound)
    end

    context 'when the ignore option is provided' do

      context 'when the response is 404' do

        let(:params) do
          { ignore: 404 }
        end

        it 'returns false' do
          expect(client.get(index: 'foo', type: 'bar', id: '1', ignore: 404)).to eq(false)
        end
      end
    end
  end
end
