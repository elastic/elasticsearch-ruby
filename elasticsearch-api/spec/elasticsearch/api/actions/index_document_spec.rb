# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#index' do

  let(:expected_args) do
    [
        request_type,
        url,
        params,
        body,
        {}
    ]
  end

  let(:request_type) do
    'POST'
  end

  let(:params) do
    { }
  end

  let(:url) do
    'foo/bar'
  end

  let(:body) do
    { foo: 'bar' }
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :index argument' do
    expect {
      client.index(type: 'bar')
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.index(index: 'foo', type: 'bar', body: body)).to eq({})
  end

  context 'when a specific id is provided' do

    let(:request_type) do
      'PUT'
    end

    let(:url) do
      'foo/bar/1'
    end

    it 'performs the request' do
      expect(client_double.index(index: 'foo', type: 'bar', id: '1', body: body)).to eq({})
    end
  end

  context 'when URL parameters are provided' do

    let(:request_type) do
      'POST'
    end

    let(:url) do
      'foo/bar'
    end

    let(:params) do
      { op_type: 'create' }
    end

    it 'passes the URL params' do
      expect(client_double.index(index: 'foo', type: 'bar', op_type: 'create', body: body)).to eq({})
    end

    context 'when a specific id is provided' do

      let(:request_type) do
        'PUT'
      end

      let(:url) do
        'foo/bar/1'
      end

      let(:params) do
        { op_type: 'create' }
      end

      it 'passes the URL params' do
        expect(client_double.index(index: 'foo', type: 'bar', id: '1', op_type: 'create', body: body)).to eq({})
      end
    end
  end

  context 'when the request needs to be URL-escaped' do
    let(:request_type) do
      'PUT'
    end

    let(:url) do
      'foo/bar%2Fbam/123'
    end

    it 'URL-escapes the parts' do
      expect(client_double.index(index: 'foo', type: 'bar/bam', id: '123', body: body)).to eq({})
    end
  end

  context 'when an invalid URL parameter is provided' do

    it 'raises and ArgumentError' do
      expect {
        client.index(index: 'foo', type: 'bar', id: '1', qwerty: 'yuiop')
      }.to raise_exception(ArgumentError)
    end
  end
end
