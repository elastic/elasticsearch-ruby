require 'spec_helper'

describe 'client#delete' do

  let(:expected_args) do
    [
        'DELETE',
        'foo/bar/1',
        params,
        nil
    ]
  end

  let(:params) do
    {}
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :index argument' do
    expect {
      client.delete(type: 'bar', id: '1')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :type argument' do
    expect {
      client.delete(index: 'foo', id: '1')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :id argument' do
    expect {
      client.delete(index: 'foo', type: 'bar')
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.delete(index: 'foo', type: 'bar', id: '1')).to eq({})
  end

  context 'when url params are provided' do

    let(:params) do
      { routing: 'abc123' }
    end

    it 'performs the request' do
      expect(client_double.delete(index: 'foo', type: 'bar', id: '1', routing: 'abc123')).to eq({})
    end
  end

  context 'when invalid url params are provided' do

    it 'raises an ArgumentError' do
      expect {
        client.delete(index: 'foo', type: 'bar', id: '1', qwertypoiuy: 'asdflkjhg')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when the url params need to be escaped' do

    let(:expected_args) do
      [
          'DELETE',
          'foo%5Ebar/bar%2Fbam/1',
          params,
          nil
      ]
    end

    it 'escapes the url params' do
      expect(client_double.delete(index: 'foo^bar', type: 'bar/bam', id: 1)).to eq({})
    end
  end

  context 'when the index is not found' do

    before do
      expect(client).to receive(:perform_request).and_raise(NotFound)
    end

    it 'raises the exception' do
      expect {
        client.delete(index: 'foo', type: 'bar', id: 'XXX')
      }.to raise_exception(NotFound)
    end

    context 'when the :ignore option is provided' do

      it 'does not raise the NotFound exception' do
        expect(client.delete(index: 'foo', type: 'bar', id: 1, ignore: 404)).to eq(false)
      end
    end
  end
end
