require 'spec_helper'

describe 'client.cluster#put_template' do

  let(:expected_args) do
    [
        'PUT',
        url,
        params,
        body,
        nil
    ]
  end

  let(:url) do
    '_template/foo'
  end

  let(:body) do
    { template: 'bar' }
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.indices.put_template(name: 'foo', body: { template: 'bar' })).to eq({})
  end

  context 'when there is no name specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.put_template(body: {})
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when there is no body specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.put_template(name: 'foo')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when parameters are specified' do

    let(:params) do
      { order: 3 }
    end

    let(:url) do
      '_template/foo'
    end

    let(:body) do
      {}
    end

    it 'performs the request' do
      expect(client_double.indices.put_template(name: 'foo', order: 3, body: {})).to eq({})
    end
  end

  context 'when the path needs to be URL-escaped' do

    let(:url) do
      '_template/foo%5Ebar'
    end

    let(:body) do
      {}
    end

    it 'performs the request' do
      expect(client_double.indices.put_template(name: 'foo^bar', body: {})).to eq({})
    end
  end
end
