require 'spec_helper'

describe 'client#update' do

  let(:expected_args) do
    [
        'POST',
        url,
        params,
        body
    ]
  end

  let(:body) do
    { doc: { } }
  end

  let(:url) do
    'foo/bar/1/_update'
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  let(:params) do
    {}
  end

  it 'requires the :index argument' do
    expect {
      client.update(type: 'bar', id: '1')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :type argument' do
    expect {
      client.update(index: 'foo', id: '1')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :id argument' do
    expect {
      client.update(index: 'foo', type: 'bar')
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.update(index: 'foo', type: 'bar', id: '1', body: { doc: {} })).to eq({})
  end

  context 'when URL parameters are provided' do

    let(:url) do
      'foo/bar/1/_update'
    end

    let(:params) do
      { version: 100 }
    end

    let(:body) do
      {}
    end

    it 'performs the request' do
      expect(client_double.update(index: 'foo', type: 'bar', id: '1', version: 100, body: {}))
    end
  end

  context 'when invalid parameters are specified' do

    it 'raises an ArgumentError' do
      expect {
        client.update(index: 'foo', type: 'bar', id: '1', body: { doc: {} }, qwertypoiuy: 'asdflkjhg')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when the request needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/bar%2Fbam/1/_update'
    end

    let(:body) do
      {}
    end

    it 'escapes the parts' do
      expect(client_double.update(index: 'foo^bar', type: 'bar/bam', id: '1', body: {}))
    end
  end

  context 'when a NotFound exception is raised' do

    before do
      allow(client).to receive(:perform_request).and_raise(NotFound)
    end

    it 'raises it to the user' do
      expect {
        client.update(index: 'foo', type: 'bar', id: 'XXX')
      }.to raise_exception(NotFound)
    end

    context 'when the :ignore parameter is specified' do

      it 'does not raise the error to the user' do
        expect(client.update(index: 'foo', type: 'bar', id: 'XXX', ignore: 404)).to eq(false)
      end
    end
  end
end
