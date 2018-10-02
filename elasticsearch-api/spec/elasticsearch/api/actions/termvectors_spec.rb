require 'spec_helper'

describe 'client#termvectors' do

  let(:expected_args) do
    [
        'GET',
        url,
        params,
        body
    ]
  end

  let(:url) do
    'foo/bar/123/_termvectors'
  end

  let(:params) do
    {}
  end

  let(:body) do
    {}
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :index argument' do
    expect {
      client.termvectors(type: 'bar', id: '1')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :type argument' do
    expect {
      client.termvectors(index: 'foo', id: '1')
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.termvectors(index: 'foo', type: 'bar', id: '123', body: {})).to eq({})
  end

  context 'when the older api name \'termvector\' is used' do

    let(:url) do
      'foo/bar/123/_termvector'
    end

    it 'performs the request' do
      expect(client_double.termvector(index: 'foo', type: 'bar', id: '123', body: {})).to eq({})
    end
  end
end
